// 
//      Filename:  jtag.h
// 
//    	Description: JTAG code stolen from Kolja Waschk, ixo.de, usb-jtag converter
// 
//      Version:  1.0
//      Created:  04/07/11 13:25:44
//      Revision:  none
// 
//      Author:  Alexander Lown (http://www.eezysys.co.uk), ali@lown.me.uk
//
//	Copyright(c) 2010, Alexander Lown
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

#include <fx2regs.h>

#ifndef JTAG_H
#define JTAG_H

//Convenience naming
#define TPORT       IOC    
__sbit __at 0xA0    TDI;
__sbit __at 0xA1    TDO;
__sbit __at 0xA2    TCK;
__sbit __at 0xA3    TMS;
__sbit __at 0xA7    LED;

void jtag_init(void);

//Standard USB Blaster form (minus AS/PS)
//d.0 => TCK
//d.1 => TMS
//d.4 => TDI
//d.5 => LED
void jtag_set(unsigned char d);

//Returned data form
//d.0 <= TDO
unsigned char jtag_set_get(unsigned char d);

//Shift out  lsb, TCK = 1, shift right, TCK = 0 *8
void jtag_shiftout(unsigned char x);

//Read TDO, then shift out (as above) *8
unsigned char jtag_shiftinout(unsigned char x);

#endif


