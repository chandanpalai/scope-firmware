#define RUN_TEST
// =====================================================================================
// 
//      Filename:  main.c
// 
//    	Description:  Main routine for the generic input boards
// 
//      Version:  1.0
//      Created:  27/02/11 17:55:47
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

#include "usart.h"
#include "eeprom.h"
#include "input.h"

#include <htc.h>
__CONFIG(FOSC_HS & WDTE_OFF & PWRTE_ON & BOREN_OFF & LVP_OFF & CP_OFF);
#define _XTAL_FREQ 20000000

#define setToggle(x) x=!x
#define delay1s (__delay_ms(250);__delay_ms(250);__delay_ms(250);__delay_ms(250);)

unsigned char devid;
int devcaps;
unsigned char usart_curbyte;
unsigned char usart_curpacket[3];

void init()
{
    pseudoRegisters_init();

    GIE = 1;

    usart_curbyte = 0;

    if(devcaps & CAP_USART)
        usart_init();
}

void interrupt isr(void)
{
    if(devcaps & CAP_USART)
    {
        if(TXIF)
        {
            TXIF = 0;
        }
        if(RCIF)
        {
            //Recieved data
            usart_curpacket[usart_curbyte] = usart_getch();
            usart_curbyte++;
            if(usart_curbyte == 3)
            {
                //Process packet here
                usart_curbyte = 0;
            }

            RCIF = 0;
        }
    }
}

int getCaps(unsigned char devid)
{
    switch(devid)
    {
        case 0xA0:
            return CAP_USART & CAP_RLY0 & CAP_3AN;
            break;
        case 0xA2:
            return CAP_USART & CAP_MUX & CAP_RLY0 & CAP_RLY1 & CAP_ALLAN;
            break;
        default:
            break;
    }
}

void main(void)
{
    devid = eeprom_getch(0x00);
    devcaps = getCaps(devid);

    init();

    if(devcaps & CAP_USART)
    {
        unsigned char acked = 0;
        while(!acked)
        {
            usart_putch(0x02);
            usart_putch(devid);
            usart_putch(0x00);
            __delay_ms(100);
        }
    }

    while(1)
    {

    }
}
