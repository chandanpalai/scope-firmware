// =====================================================================================
// 
//      Filename:  process.c
// 
//    	Description:  
// 
//      Version:  1.0
//      Created:  03/14/11 13:31:16
//      Revision:  none
// 
//      Author:  Alexander Lown (http://www.eezysys.co.uk), ali@lown.me.uk
//
//	Copyright(c) 2011, Alexander Lown
//	All rights reserved.
//	
//	Redistribution and use of source and binary forms, with or without modification, 
//	are permitted provided that the following conditions are met:
//	* Redistributions of source code must retain the above copyright notice, this
//	  list of conditions and the following disclaimer.
//	* Redistributions in binary form must reproduce the above copyright notice. this 
//	  list of conditions and the following disclaimer in the documentation and/or
//	  other materials provided with the distribution.
//	* Neither the name of eeZySys nor the names of its contributors may be used to
//	  endorse or promote products derived from this software without specific
//	  prior written permission.
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.	
// 
// =====================================================================================

#include "eeprom.h"
#include "jtag.h"
#include "process.h"

#include <autovector.h>
#include "setupdat.h"

volatile __bit handleSetup = FALSE;
volatile __bit handleSuspended = FALSE;

//Internal buffer for JTAG in/out comms
static BOOL isShiftWriteOnly;
static WORD outPending;
static BYTE clockBytes;
#define OUTBUF_LEN 0x100
__xdata __at 0xE000 BYTE outBuffer[OUTBUF_LEN];
static BYTE firstDataIOBuffer;
static BYTE firstFreeIOBuffer;

BOOL handle_get_interface(BYTE ifc, BYTE* alt_ifc)
{
        ifc = ifc;
        alt_ifc = alt_ifc;
		return TRUE;
}
BOOL handle_set_interface(BYTE ifc, BYTE alt_ifc)
{
        ifc = ifc;
        alt_ifc = alt_ifc;
		return TRUE;
}

BOOL handle_get_configuration()
{
		return 1;
}
BOOL handle_set_configuration(BYTE cfg)
{
        cfg = cfg;
		return TRUE;
}

BOOL handle_vendorcommand(BYTE cmd)
{
        cmd = cmd;
		return TRUE;
}

void init_user()
{
		EA = 0;


		CPUCS = 0x12;
		IFCONFIG = 0xA3;
		SYNCDELAY();
		
        REVCTL = 0x01; SYNCDELAY();

		//Setup debug endpoints
        EP1OUTCFG = 0x00; SYNCDELAY();
		EP1OUTCFG = 0xA0; SYNCDELAY(); //BULK

        EP1INCFG = 0x00; SYNCDELAY();
		EP1INCFG = 0xA0; SYNCDELAY(); 

		REARMEP1OUT();

		//Slave EPs setup
		EP2CFG = 0xA2; SYNCDELAY(); //BULK OUT 512 2x
		EP4CFG = 0xA2; SYNCDELAY(); //BULK OUT 512 2x
		EP6CFG = 0xE2; SYNCDELAY(); //BULK IN 512 2x
		EP8CFG = 0xE2; SYNCDELAY(); //BULK IN 512 2x

		//Slave FIFO setup
		FIFORESET = 0x80; SYNCDELAY();
		FIFORESET = 0x82; SYNCDELAY();
		FIFORESET = 0x84; SYNCDELAY();
		FIFORESET = 0x86; SYNCDELAY();
		FIFORESET = 0x88; SYNCDELAY();
		FIFORESET = 0x00; SYNCDELAY();

		PINFLAGSAB = 0x98; SYNCDELAY(); //EP2EF, EP4EF
		PINFLAGSCD = 0xEF; SYNCDELAY(); //EP6FF, EP8FF
		FIFOPINPOLAR = 0x00; SYNCDELAY();

		EP2FIFOCFG = 0x00; SYNCDELAY();

		OUTPKTEND = 0x82; SYNCDELAY();
		OUTPKTEND = 0x82; SYNCDELAY();

		OUTPKTEND = 0x84; SYNCDELAY();
		OUTPKTEND = 0x84; SYNCDELAY();

		EP6FIFOCFG = 0x00; SYNCDELAY();
		EP6FIFOCFG = 0x0D; SYNCDELAY(); //AUTOIN, ZEROLEN, WW

        EP8FIFOCFG = 0x00; SYNCDELAY();


        //Init JTAG subsyttem
        eeprom_init();
        jtag_init();

        isShiftWriteOnly = FALSE;
        outPending = 0;
        clockBytes = 0;
        firstDataIOBuffer = 0;
        firstFreeIOBuffer = 0;

        AUTOPTRSETUP = 0x07; //EXTACC, 1FZ, 2FZ

		EA = 1;
}

void writeOutputByte(BYTE d)
{
    outBuffer[firstFreeIOBuffer] = d;
    firstFreeIOBuffer = (firstFreeIOBuffer+1) & 0xFF;
    outPending++;
}

//For full details of the JTAG system, refer to ixo.de and the original code
//In short: there are 2 modes, bit banging, and byte shift
//Bit banging: d.7? switch to byte-shift. d.6? read bit. Otherwise just pass to jtag_set
//Byte shift: send to jtag_shiftout. If d.6? when d.7: use jtag_shiftinout instead
void processIO()
{
		if(!(EP1OUTCS&0x02))
		{
				switch(EP1OUTBUF[0])
				{
						case 0x14:
								EP8FIFOBUF[0] = 0x15;
								EP8FIFOBUF[1] = EP1OUTBC;
								EP8FIFOBUF[2] = EP1INBC;
								EP8FIFOBUF[3] = EP2BCH;
								EP8FIFOBUF[4] = EP2BCL;
								EP8FIFOBUF[5] = EP4BCH;
								EP8FIFOBUF[6] = EP4BCL;
								EP8FIFOBUF[7] = EP6BCH;
								EP8FIFOBUF[8] = EP6BCL;
								EP8FIFOBUF[9] = EP8BCH;
								EP8FIFOBUF[10] = EP8BCL;
								EP8FIFOBUF[11] = EP1OUTCS;
								EP8FIFOBUF[12] = EP1INCS;
								EP8FIFOBUF[13] = EP2CS;
								EP8FIFOBUF[14] = EP4CS;
								EP8FIFOBUF[15] = EP6CS;
								EP8FIFOBUF[16] = EP8CS;
								EP8FIFOBUF[17] = EP2FIFOBCH;
								EP8FIFOBUF[18] = EP2FIFOBCL;
								EP8FIFOBUF[19] = EP4FIFOBCH;
								EP8FIFOBUF[20] = EP4FIFOBCL;
								EP8FIFOBUF[21] = EP6FIFOBCH;
								EP8FIFOBUF[22] = EP6FIFOBCL;
								EP8FIFOBUF[23] = EP8FIFOBCH;
								EP8FIFOBUF[24] = EP8FIFOBCL;
								EP8FIFOBUF[26] = EP2CFG;
								EP8FIFOBUF[27] = EP4CFG;
								EP8FIFOBUF[28] = EP6CFG;
								EP8FIFOBUF[29] = EP8CFG;
								EP8FIFOBUF[30] = EP2FIFOCFG;
								EP8FIFOBUF[31] = EP4FIFOCFG;
								EP8FIFOBUF[32] = EP6FIFOCFG;
								EP8FIFOBUF[33] = EP8FIFOCFG;
								EP8FIFOBUF[34] = FIFORESET;
								EP8FIFOBUF[35] = OUTPKTEND;
                                EP8FIFOBUF[36] = outPending;

                                EP8BCH = 0;
                                EP8BCL = 37;
								break;
				}

				REARMEP1OUT();
		}

        if(!(EP1INCS & 0x02))
        {
                if(outPending > 0)
                {
                        //Write outbuffer back to EP1IN
                        BYTE o,n;

                        AUTOPTRH2 = MSB(EP1INBUF);
                        AUTOPTRL2 = LSB(EP1INBUF);

                        XAUTODAT2 = 0x31; //Some sort of control byte from FTDI
                        XAUTODAT2 = 0x60;

                        if(outPending > 0x3E)
                        {
                            n = 0x3E;
                            outPending -= n;
                        }
                        else
                        {
                            n = outPending;
                            outPending = 0;
                        }

                        o = n;

                        AUTOPTRH1 = MSB(outBuffer);
                        AUTOPTRL1 = firstDataIOBuffer;
                        while(n--)
                        {
                            XAUTODAT2 = XAUTODAT1;
                            AUTOPTRH1 = MSB(outBuffer);
                        };
                        firstDataIOBuffer = AUTOPTRL1;

                        SYNCDELAY();
                        EP1INBC = 2 + o; SYNCDELAY(); //Arm EP1
                }
        }

        if((!(EP2468STAT & 0x01)) && (outPending < (OUTBUF_LEN-0x3F))) //At least 1 packet space needed
        {
                WORD i, n = (EP2BCH<<8)|EP2BCL;

                LED = !LED;

                AUTOPTRH1 = MSB(EP2FIFOBUF);
                AUTOPTRL1 = LSB(EP2FIFOBUF);

                for(i=0; i<n;)
                {
                        //Shift mode
                        if(clockBytes > 0)
                        {
                                WORD m;
                                m = n-i;
                                if(clockBytes < m) m = clockBytes;
                                clockBytes -= m;
                                i += m;

                                //Shift out 
                                if(isShiftWriteOnly)
                                {
                                    while(m--) jtag_shiftout(XAUTODAT1);
                                }
                                else
                                {
                                    while(m--) writeOutputByte(jtag_shiftinout(XAUTODAT1));
                                }
                        }
                        //Byte mode
                        else
                        {
                                BYTE d = XAUTODAT1;
                                isShiftWriteOnly = d & bmBIT6;

                                if(d & bmBIT7)
                                    clockBytes = d & 0x3F;
                                else
                                {
                                    if(isShiftWriteOnly)
                                        jtag_set(d);
                                    else
                                        writeOutputByte(jtag_set_get(d));
                                }
                                i++;
                        }
                }

                SYNCDELAY();
                OUTPKTEND = 0x82; SYNCDELAY();
            }
}

void init_int()
{
		USE_USB_INTS();

		ENABLE_SUDAV();
		ENABLE_USBRESET();
		ENABLE_HISPEED();
		EA = 1;
}

void init()
{
		SETCPUFREQ(CLK_48M);
		init_user();
		init_int();
}

void main()
{
		RENUMERATE_UNCOND();
		init();

		while(1)
		{
				processIO();

				if(handleSetup)
				{
						handleSetup = FALSE;
						handle_setupdata();
				}
		}
}

void sudav_isr() __interrupt SUDAV_ISR
{
		handleSetup = TRUE;
		CLEAR_SUDAV();
}
void usbreset_isr() __interrupt USBRESET_ISR
{
		handle_hispeed(FALSE);
		CLEAR_USBRESET();
}
void hispeed_isr() __interrupt HISPEED_ISR
{
		handle_hispeed(TRUE);
		CLEAR_HISPEED();
}
