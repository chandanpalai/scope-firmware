
// 
//      Filename:  input.h
// 
//    	Description:  Defines the registers and capabilites, as described in the spec (eeprom-codes.txt)
// 
//      Version:  1.0
//      Created:  03/01/11 15:11:19
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

#ifndef INPUT_H
#define INPUT_H

#define CAP_USART  0x01
#define CAP_MUX    0x02
#define CAP_RLY0   0x04
#define CAP_RLY1   0x08
#define CAP_AN0    0x10
#define CAP_AN1    0x20
#define CAP_AN2    0x30
#define CAP_AN3    0x40
#define CAP_3AN    (CAP_AN0 & CAP_AN1 & CAP_AN2)
#define CAP_ALLAN  (CAP_3AN & CAP_AN3)

unsigned char RELAY;
#define RELAY0 (RELAY & (1 << 0))
#define RELAY1 (RELAY & (1 << 1))

unsigned char MUX;

void pseudoRegisters_init()
{
		RELAY = 0x00;
		MUX = 0x00;
}

#endif INPUT_H



