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

#include "process.h"

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

BOOL handle_vendorcommand(BYTE cmd)
{
		return FALSE;
}

void init_user()
{
		EA = 0;


		CPUCS = 0x12;
		IFCONFIG = 0xA3;
		SYNCDELAY();
		
        REVCTL = 0x01; SYNCDELAY();

		//Setup debug endpoints
		EP1OUTCFG = 0xA0; SYNCDELAY(); //BULK
		EP1INCFG = 0xA0; SYNCDELAY(); 
		REARMEP1OUT();

		//Setup LED output, and light it
		PORTCCFG &= ~0x80;
		OEC |= 0x80;

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


		//Auto-out
		EP2FIFOCFG = 0x00; SYNCDELAY();
		EP2FIFOCFG = 0x11; SYNCDELAY(); //WW

		//Arm the pump
		OUTPKTEND = 0x82; SYNCDELAY();
		OUTPKTEND = 0x82; SYNCDELAY();

		EP6FIFOCFG = 0x00; SYNCDELAY();
		EP6FIFOCFG = 0x0D; SYNCDELAY(); //AUTOIN, ZEROLEN, WW
		EP8FIFOCFG = 0x00; SYNCDELAY();
		EP8FIFOCFG = 0x0D; SYNCDELAY(); //AUTOIN, ZEROLEN, WW
		EP6AUTOINLENH = 0x02; SYNCDELAY();
		EP6AUTOINLENL = 0x00; SYNCDELAY();
		EP8AUTOINLENH = 0x02; SYNCDELAY();
		EP8AUTOINLENL = 0x00; SYNCDELAY();

		EA = 1;
}

bit oldstate = FALSE;


void processIO()
{
		if(!(EP1OUTCS&0x02))
		{
				switch(EP1OUTBUF[0])
				{
						case 0x14:
								EP1INBUF[0] = 0x15;
								EP1INBUF[1] = EP1OUTBC;
								EP1INBUF[2] = EP1INBC;
								EP1INBUF[3] = EP2BCH;
								EP1INBUF[4] = EP2BCL;
								EP1INBUF[5] = EP4BCH;
								EP1INBUF[6] = EP4BCL;
								EP1INBUF[7] = EP6BCH;
								EP1INBUF[8] = EP6BCL;
								EP1INBUF[9] = EP8BCH;
								EP1INBUF[10] = EP8BCL;
								EP1INBUF[11] = EP1OUTCS;
								EP1INBUF[12] = EP1INCS;
								EP1INBUF[13] = EP2CS;
								EP1INBUF[14] = EP4CS;
								EP1INBUF[15] = EP6CS;
								EP1INBUF[16] = EP8CS;
								EP1INBUF[17] = EP2FIFOBCH;
								EP1INBUF[18] = EP2FIFOBCL;
								EP1INBUF[19] = EP4FIFOBCH;
								EP1INBUF[20] = EP4FIFOBCL;
								EP1INBUF[21] = EP6FIFOBCH;
								EP1INBUF[22] = EP6FIFOBCL;
								EP1INBUF[23] = EP8FIFOBCH;
								EP1INBUF[24] = EP8FIFOBCL;
								EP1INBUF[26] = EP2CFG;
								EP1INBUF[27] = EP4CFG;
								EP1INBUF[28] = EP6CFG;
								EP1INBUF[29] = EP8CFG;
								EP1INBUF[30] = EP2FIFOCFG;
								EP1INBUF[31] = EP4FIFOCFG;
								EP1INBUF[32] = EP6FIFOCFG;
								EP1INBUF[33] = EP8FIFOCFG;
								EP1INBUF[34] = FIFORESET;
								EP1INBUF[35] = OUTPKTEND;
								EP1INBC = 36;
								break;
				}

				REARMEP1OUT();
		}
}
