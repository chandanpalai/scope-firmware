// =====================================================================================
// 
//      Filename:  main.c
// 
//    	Description: Main loop for the cypress firmware 
// 
//      Version:  1.0
//      Created:  03/14/11 12:42:40
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

#include <fx2macros.h>
#include <fx2ints.h>
#include <autovector.h>
#include <delay.h>
#include <setupdat.h>

#include "process.h"

volatile bit handleSetup = FALSE;
volatile bit handleSuspended = FALSE;

void init();
void init_int();
void main();

void init()
{
		SETCPUFREQ(CLK_48M);
		init_int();
		init_user();
}
void init_int()
{
		USE_USB_INTS();

		ENABLE_SUDAV();
		ENABLE_USBRESET();
		ENABLE_HISPEED();
		//ENABLE_SUSPEND();
		//ENABLE_RESUME();
		EA = 1;
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

void sudav_isr() interrupt SUDAV_ISR
{
		handleSetup = TRUE;
		CLEAR_SUDAV();
}
void usbreset_isr() interrupt USBRESET_ISR
{
		handle_hispeed(FALSE);
		CLEAR_USBRESET();
}
void hispeed_isr() interrupt HISPEED_ISR
{
		handle_hispeed(TRUE);
		CLEAR_HISPEED();
}
/*void resume_isr() interrupt RESUME_ISR
{
		CLEAR_RESUM();
}
void suspend_isr() interrupt SUSPEND_ISR
{
		handleSuspended = TRUE;
		CLEAR_SUSPEND();
}*/
