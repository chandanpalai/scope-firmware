
// 
//      Filename:  process.h
// 
//    	Description:  ProcessIO and hondles configuration
// 
//      Version:  1.0
//      Created:  03/14/11 13:28:42
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

#include <eputils.h>
#include <fx2macros.h>
#include <fx2ints.h>
#include <autovector.h>
#include <delay.h>
#include <setupdat.h>

#ifndef PROCESS_H
#define PROCESS_H

#define SYNCDELAY() {SYNCDELAY4; SYNCDELAY4; SYNCDELAY4; SYNCDELAY4; SYNCDELAY4;} 
#define REARMEP1OUT() {EP1OUTBC=0x00; SYNCDELAY();}

BOOL handle_get_interface(BYTE ifc, BYTE* alt_ifc);
BOOL handle_set_interface(BYTE ifc, BYTE alt_ifc);

BOOL handle_get_configuration();
BOOL handle_set_configuration(BYTE cfg);

BOOL handle_vendorcommand(BYTE cmd);

void init_user();
void processIO();

#endif
