/*-----------------------------------------------------------------------------
 * Code that turns a Cypress FX2 USB Controller into an USB JTAG adapter
 *-----------------------------------------------------------------------------
 * Copyright (C) 2005..2007 Kolja Waschk, ixo.de
 *-----------------------------------------------------------------------------
 * Check hardware.h/.c if it matches your hardware configuration (e.g. pinout).
 * Changes regarding USB identification should be made in product.inc!
 *-----------------------------------------------------------------------------
 * This code is part of usbjtag. usbjtag is free software; you can redistribute
 * it and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version. usbjtag is distributed in the hope
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.  You should have received a
 * copy of the GNU General Public License along with this program in the file
 * COPYING; if not, write to the Free Software Foundation, Inc., 51 Franklin
 * St, Fifth Floor, Boston, MA  02110-1301  USA
 *-----------------------------------------------------------------------------
 */
 
// The firmware version should be regularly updated.
#define FWVERSION "4.2.0"

#include <fx2regs.h>
#include <fx2macros.h>
#include <fx2types.h>
#include <fx2ints.h>
#include <autovector.h>
#include <delay.h>
#include <setupdat.h>

#include "eeprom.h"
#include "hardware.h"

#define        bmRT_DIR_MASK           (0x1 << 7)
#define        bmRT_DIR_IN             (1 << 7)
#define        bmRT_DIR_OUT            (0 << 7)

#define        bmRT_TYPE_MASK          (0x3 << 5)
#define        bmRT_TYPE_STD           (0 << 5)
#define        bmRT_TYPE_CLASS         (1 << 5)
#define        bmRT_TYPE_VENDOR        (2 << 5)
#define        bmRT_TYPE_RESERVED      (3 << 5)

#define        bmRT_RECIP_MASK         (0x1f << 0)
#define        bmRT_RECIP_DEVICE       (0 << 0)
#define        bmRT_RECIP_INTERFACE    (1 << 0)
#define        bmRT_RECIP_ENDPOINT     (2 << 0)
#define        bmRT_RECIP_OTHER        (3 << 0)


#define bRequestType	SETUPDAT[0]
#define bRequest		SETUPDAT[1]
#define wValueL			SETUPDAT[2]
#define wValueH			SETUPDAT[3]
#define wIndexL			SETUPDAT[4]
#define wIndexH			SETUPDAT[5]
#define wLengthL		SETUPDAT[6]
#define wLengthH		SETUPDAT[7]

#define MSB(x) (((unsigned short) x) >> 8)
#define LSB(x) (((unsigned short) x) & 0xff)


//-----------------------------------------------------------------------------
// Define USE_MOD256_OUTBUFFER:
// Saves about 256 bytes in code size, improves speed a little.
// A further optimization could be not to use an extra output buffer at 
// all, but to write directly into EP1INBUF. Not implemented yet. When 
// downloading large amounts of data _to_ the target, there is no output
// and thus the output buffer isn't used at all and doesn't slow down things.

#define USE_MOD256_OUTBUFFER 1

//-----------------------------------------------------------------------------
// Global data

#define FALSE 0
#define TRUE  1
static BOOL got_sud;
static BOOL Running;
static BOOL WriteOnly;

static BYTE ClockBytes;
static WORD Pending;

#ifdef USE_MOD256_OUTBUFFER
  static BYTE FirstDataInOutBuffer;
  static BYTE FirstFreeInOutBuffer;
#else
  static WORD FirstDataInOutBuffer;
  static WORD FirstFreeInOutBuffer;
#endif

#ifdef USE_MOD256_OUTBUFFER
  /* Size of output buffer must be exactly 256 */
  #define OUTBUFFER_LEN 0x100
  /* Output buffer must begin at some address with lower 8 bits all zero */
  xdata at 0xE000 BYTE OutBuffer[OUTBUFFER_LEN];
#else
  #define OUTBUFFER_LEN 0x200
  static xdata BYTE OutBuffer[OUTBUFFER_LEN];
#endif

//-----------------------------------------------------------------------------

void usb_jtag_init(void)              // Called once at startup
{
   WORD tmp;

   Running = FALSE;
   ClockBytes = 0;
   Pending = 0;
   WriteOnly = TRUE;
   FirstDataInOutBuffer = 0;
   FirstFreeInOutBuffer = 0;

   ProgIO_Init();

   ProgIO_Enable();

   // Make Timer2 reload at 100 Hz to trigger Keepalive packets

   tmp = 65536 - ( 48000000 / 12 / 100 );
   RCAP2H = tmp >> 8;
   RCAP2L = tmp & 0xFF;
   CKCON = 0; // Default Clock
   T2CON = 0x04; // Auto-reload mode using internal clock, no baud clock.

   // Enable Autopointer
   AUTOPTRSETUP = 0x07; //EXTACC, 1FZ, 2FZ

   // define endpoint configuration

   REVCTL = 3; SYNCDELAY4;							// Allow FW access to FIFO buffer
   FIFORESET = 0x80; SYNCDELAY4;						// From now on, NAK all, reset all FIFOS
   FIFORESET  = 0x02; SYNCDELAY4;					// Reset FIFO 2
   FIFORESET  = 0x04; SYNCDELAY4;					// Reset FIFO 4
   FIFORESET  = 0x06; SYNCDELAY4;					// Reset FIFO 6
   FIFORESET  = 0x08; SYNCDELAY4;					// Reset FIFO 8
   FIFORESET  = 0x00; SYNCDELAY4;					// Restore normal behaviour

   EP1OUTCFG  = 0xA0; SYNCDELAY4;					// Endpoint 1 Type Bulk			
   EP1INCFG   = 0xA0; SYNCDELAY4;					// Endpoint 1 Type Bulk

   EP2FIFOCFG = 0x00; SYNCDELAY4;					// Endpoint 2
   EP2CFG     = 0xA2; SYNCDELAY4;					// Endpoint 2 Valid, Out, Type Bulk, Double buffered

   EP4FIFOCFG = 0x00; SYNCDELAY4;					// Endpoint 4 not used
   EP4CFG     = 0xA0; SYNCDELAY4;					// Endpoint 4 not used

   REVCTL = 0; SYNCDELAY4;							// Reset FW access to FIFO buffer, enable auto-arming when AUTOOUT is switched to 1

   EP6CFG     = 0xA2; SYNCDELAY4;					// Out endpoint, Bulk, Double buffering
   EP6FIFOCFG = 0x00; SYNCDELAY4;					// Firmware has to see a rising edge on auto bit to enable auto arming
   EP6FIFOCFG = bmAUTOOUT | bmWORDWIDE; SYNCDELAY4;	// Endpoint 6 used for user communicationn, auto commitment, 16 bits data bus

   EP8CFG     = 0xE0; SYNCDELAY4;					// In endpoint, Bulk
   EP8FIFOCFG = 0x00; SYNCDELAY4;					// Firmware has to see a rising edge on auto bit to enable auto arming
   EP8FIFOCFG = bmAUTOIN  | bmWORDWIDE; SYNCDELAY4;	// Endpoint 8 used for user communication, auto commitment, 16 bits data bus

   EP8AUTOINLENH = 0x00; SYNCDELAY4;					// Size in bytes of the IN data automatically commited (64 bytes here, but changed dynamically depending on the connection)
   EP8AUTOINLENL = 0x40; SYNCDELAY4;					// Can use signal PKTEND if you want to commit a shorter packet

   // Out endpoints do not come up armed
   // Since the defaults are double buffered we must write dummy byte counts twice
   EP2BCL = 0x80; SYNCDELAY4;						// Arm EP2OUT by writing byte count w/skip.=
   EP4BCL = 0x80; SYNCDELAY4;
   EP2BCL = 0x80; SYNCDELAY4;						// Arm EP4OUT by writing byte count w/skip.= 
   EP4BCL = 0x80; SYNCDELAY4;
   
   // JTAG from FX2 enabled by default
   IOC |= (1 << 7);
   
   // Put the FIFO in sync mode
   IFCONFIG &= ~bmASYNC;
}

void OutputByte(BYTE d)
{
#ifdef USE_MOD256_OUTBUFFER
   OutBuffer[FirstFreeInOutBuffer] = d;
   FirstFreeInOutBuffer = ( FirstFreeInOutBuffer + 1 ) & 0xFF;
#else
   OutBuffer[FirstFreeInOutBuffer++] = d;
   if(FirstFreeInOutBuffer >= OUTBUFFER_LEN) FirstFreeInOutBuffer = 0;
#endif
   Pending++;
}

//-----------------------------------------------------------------------------
// usb_jtag_activity does most of the work. It now happens to behave just like
// the combination of FT245BM and Altera-programmed EPM7064 CPLD in Altera's
// USB-Blaster. The CPLD knows two major modes: Bit banging mode and Byte
// shift mode. It starts in Bit banging mode. While bytes are received
// from the host on EP2OUT, each byte B of them is processed as follows:
//
// Please note: nCE, nCS, LED pins and DATAOUT actually aren't supported here.
// Support for these would be required for AS/PS mode and isn't too complicated,
// but I haven't had the time yet.
//
// Bit banging mode:
// 
//   1. Remember bit 6 (0x40) in B as the "Read bit".
//
//   2. If bit 7 (0x40) is set, switch to Byte shift mode for the coming
//      X bytes ( X := B & 0x3F ), and don't do anything else now.
//
//    3. Otherwise, set the JTAG signals as follows:
//        TCK/DCLK high if bit 0 was set (0x01), otherwise low
//        TMS/nCONFIG high if bit 1 was set (0x02), otherwise low
//        nCE high if bit 2 was set (0x04), otherwise low
//        nCS high if bit 3 was set (0x08), otherwise low
//        TDI/ASDI/DATA0 high if bit 4 was set (0x10), otherwise low
//        Output Enable/LED active if bit 5 was set (0x20), otherwise low
//
//    4. If "Read bit" (0x40) was set, record the state of TDO(CONF_DONE) and
//        DATAOUT(nSTATUS) pins and put it as a byte ((DATAOUT<<1)|TDO) in the
//        output FIFO _to_ the host (the code here reads TDO only and assumes
//        DATAOUT=1)
//
// Byte shift mode:
//
//   1. Load shift register with byte from host
//
//   2. Do 8 times (i.e. for each bit of the byte; implemented in shift.a51)
//      2a) if nCS=1, set carry bit from TDO, else set carry bit from DATAOUT
//      2b) Rotate shift register through carry bit
//      2c) TDI := Carry bit
//      2d) Raise TCK, then lower TCK.
//
//   3. If "Read bit" was set when switching into byte shift mode,
//      record the shift register content and put it into the FIFO
//      _to_ the host.
//
// Some more (minor) things to consider to emulate the FT245BM:
//
//   a) The FT245BM seems to transmit just packets of no more than 64 bytes
//      (which perfectly matches the USB spec). Each packet starts with
//      two non-data bytes (I use 0x31,0x60 here). A USB sniffer on Windows
//      might show a number of packets to you as if it was a large transfer
//      because of the way that Windows understands it: it _is_ a large
//      transfer until terminated with an USB packet smaller than 64 byte.
//
//   b) The Windows driver expects to get some data packets (with at least
//      the two leading bytes 0x31,0x60) immediately after "resetting" the
//      FT chip and then in regular intervals. Otherwise a blue screen may
//      appear... In the code below, I make sure that every 10ms there is
//      some packet.
//
//   c) Vendor specific commands to configure the FT245 are mostly ignored
//      in my code. Only those for reading the EEPROM are processed. See
//      DR_GetStatus and DR_VendorCmd below for my implementation.
//
//   All other TD_ and DR_ functions remain as provided with CY3681.
//
//-----------------------------------------------------------------------------

void usb_jtag_activity(void) // Called repeatedly while the device is idle
{
   if(!Running) return;

   ProgIO_Poll();
   
   if(!(EP1INCS & bmEPBUSY))
   {
      if(Pending > 0)
      {
         BYTE o, n;

         AUTOPTRH2 = MSB( EP1INBUF );
         AUTOPTRL2 = LSB( EP1INBUF );
       
         XAUTODAT2 = 0x31;
         XAUTODAT2 = 0x60;
       
         if(Pending > 0x3E) { n = 0x3E; Pending -= n; } 
                     else { n = Pending; Pending = 0; };
       
         o = n;

#ifdef USE_MOD256_OUTBUFFER
         AUTOPTRH1 = MSB( OutBuffer );
         AUTOPTRL1 = FirstDataInOutBuffer;
         while(n--)
         {
            XAUTODAT2 = XAUTODAT1;
            AUTOPTRH1 = MSB( OutBuffer ); // Stay within 256-Byte-Buffer
         };
         FirstDataInOutBuffer = AUTOPTRL1;
#else
         AUTOPTRH1 = MSB( &(OutBuffer[FirstDataInOutBuffer]) );
         AUTOPTRL1 = LSB( &(OutBuffer[FirstDataInOutBuffer]) );
         while(n--)
         {
            XAUTODAT2 = XAUTODAT1;

            if(++FirstDataInOutBuffer >= OUTBUFFER_LEN)
            {
               FirstDataInOutBuffer = 0;
               AUTOPTRH1 = MSB( OutBuffer );
               AUTOPTRL1 = LSB( OutBuffer );
            };
         };
#endif
         SYNCDELAY4;
         EP1INBC = 2 + o;
         TF2 = 1; // Make sure there will be a short transfer soon
      }
      else if(TF2)
      {
         EP1INBUF[0] = 0x31;
         EP1INBUF[1] = 0x60;
         SYNCDELAY4;
         EP1INBC = 2;
         TF2 = 0;
      };
   };

   if(!(EP2468STAT & bmEP2EMPTY) && (Pending < OUTBUFFER_LEN-0x3F))
   {
      //BYTE i, n = EP2BCL; // bugfix by Sune Mai (Oct 2008, https://sourceforge.net/projects/urjtag/forums/forum/682993/topic/2312452)
      WORD i, n = EP2BCL|EP2BCH<<8;

      AUTOPTRH1 = MSB( EP2FIFOBUF );
      AUTOPTRL1 = LSB( EP2FIFOBUF );

      for(i=0;i<n;)
      {
         if(ClockBytes > 0)
         {
            //BYTE m; // bugfix by Sune Mai (Oct 2008, https://sourceforge.net/projects/urjtag/forums/forum/682993/topic/2312452)
            WORD m;

            m = n-i;
            if(ClockBytes < m) m = ClockBytes;
            ClockBytes -= m;
            i += m;

            /* Shift out 8 bits from d */
         
            if(WriteOnly) /* Shift out 8 bits from d */
            {
               while(m--) ProgIO_ShiftOut(XAUTODAT1);
            }
            else /* Shift in 8 bits at the other end  */
            {
               while(m--) OutputByte(ProgIO_ShiftInOut(XAUTODAT1));
            }
        }
        else
        {
            BYTE d = XAUTODAT1;
            WriteOnly = (d & bmBIT6) ? FALSE : TRUE;

            if(d & bmBIT7)
            {
               /* Prepare byte transfer, do nothing else yet */

               ClockBytes = d & 0x3F;
            }
            else
            {
               if(WriteOnly)
                   ProgIO_Set_State(d);
               else
                   OutputByte(ProgIO_Set_Get_State(d));
            };
            i++;
         };
      };

      SYNCDELAY4;
      EP2BCL = 0x80; // Re-arm endpoint 2
   };
}

//-----------------------------------------------------------------------------
// Handler for Vendor Requests (
//-----------------------------------------------------------------------------

unsigned char handle_vendorcommand(void)
{
  // OUT requests. Pretend we handle them all...

  if ((bRequestType & bmRT_DIR_MASK) == bmRT_DIR_OUT)
  {
    if(bRequest == 0x00)
    {
      Running = 1;
    };
    return 1;
  }

  // IN requests.
    switch (bRequest){
    case 0x90: // Read EEPROM
        { // We need a block for addr
            BYTE addr = (wIndexL<<1) & 0x7F;
            EP0BUF[0] = eeprom[addr];
            EP0BUF[1] = eeprom[addr+1];
            EP0BCL = (wLengthL<2) ? wLengthL : 2; 
        }
        break;
        
    case 0x92: // change JTAG enable
        if (wIndexL == 0){			// FX2 is master of JTAG
            IOC |= (1 << 7);
        }else{						// external connector is master of JTAG
            IOC &= ~(1 << 7);
        }
        EP0BCH = 0; // Arm endpoint
        EP0BCL = 0; // # bytes to transfer
        break;
        
    case 0x93: // change synchronous/asynchronous mode
        if(wIndexL == 0){           // sync
            IFCONFIG &= ~bmASYNC;
            EP0BUF[0] = 0;
        }else{
            IFCONFIG |= bmASYNC;    // async
            EP0BUF[0] = 1;
        }
        EP0BCH = 0; // Arm endpoint
        EP0BCL = 1; 
        break;
    
    case 0x94: // get Firmware version
        {
          int i=0;
          char* ver=FWVERSION;
          while(ver[i]!='\0'){
            EP0BUF[i]=ver[i];
            i++;
          }
          EP0BCH = 0; // Arm endpoint
          EP0BCL = i; 
          break;
        }
    default:
        // dummy data
        EP0BUF[0] = 0x36;
        EP0BUF[1] = 0x83;
        EP0BCH = 0;
        EP0BCL = (wLengthL<2) ? wLengthL : 2;
    }
  
  return 1;
}

//-----------------------------------------------------------------------------

void sudav_isr() interrupt SUDAV_ISR 
{
  
  got_sud=TRUE;
  CLEAR_SUDAV();
}

BOOL handle_get_interface(BYTE ifc, BYTE* alt_ifc)
{
		return TRUE;
}
BOOL handle_set_interface(BYTE ifc, BYTE alt_ifc)
{
		return TRUE;
}

BOOL handle_get_configuration()
{
		return 1;
}
BOOL handle_set_configuration(BYTE cfg)
{
		return TRUE;
}

//-----------------------------------------------------------------------------

static void main_loop(void)
{
  while(1)
  {
    if(got_sud) handle_setupdata();
    usb_jtag_activity();
  }
}

//-----------------------------------------------------------------------------

void main(void)
{
  EA = 0; // disable all interrupts

  usb_jtag_init();
  eeprom_init();

  got_sud = FALSE;

  USE_USB_INTS();
  ENABLE_SUDAV();
  ENABLE_SOF();
  ENABLE_HISPEED();
  ENABLE_USBRESET();

  RENUMERATE_UNCOND(); // simulates disconnect / reconnect

  main_loop();
}




