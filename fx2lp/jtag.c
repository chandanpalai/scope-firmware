// =====================================================================================
// 
//      Filename:  jtag.c
// 
//    	Description: JTAG code stolen from Kolja Waschk, ixo.de, usb-jtag converter
// 
//      Version:  1.0
//      Created:  04/07/11 13:24:51
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

#include "jtag.h"
#include <fx2regs.h>

void jtag_init(void)
{
    PORTCCFG = 0x00;
    OEC = 0x8D;
}

void jtag_set(unsigned char d)
{
    TCK = d & bmBIT0;
    TMS = d & bmBIT1;
    TDI = d & bmBIT4;

    LED = d & bmBIT5;
}

unsigned char jtag_set_get(unsigned char d)
{
    jtag_set(d);
    return TDO;
}

void jtag_shiftout(unsigned char x)
{
    (void)x;
    __asm
        mov A, DPL
        ;;b0
        rrc A
        mov _TDI, C
        setb _TCK
        ;;b1
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b2
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b3
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b4
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b5
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b6
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        ;;b7
        rrc A
        clr _TCK
        mov _TDI, C
        setb _TCK
        clr _TCK
        ret
    __endasm;
}

unsigned char jtag_shiftinout(unsigned char x)
{
    (void)x;

    __asm
        mov A, DPL
        ;;b0
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b1
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b2
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b3
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b4
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b5
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b6
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK
        ;;b7
        mov C, _TDO
        rrc A
        mov _TDI, C
        setb _TCK
        clr _TCK

        mov DPL, A
        ret
    __endasm;

    return x;
}

