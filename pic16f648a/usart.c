#include <htc.h>
#include <stdio.h>
#include "usart.h"

void
usart_init(void)
{
		//Both set to inputs to enable UART
		TRISRX = 1;
		TRISTX = 1;

		SPBRG = 0; //1,250,000 from 20MHz

		BRGH = 1;
		SYNC = 0;
		SPEN = 1;

		TXIE = 1;
		TXEN = 1;

		RCIE = 1;
		CREN = 1;

}

void 
usart_putch(unsigned char byte) 
{
	/* output one byte */
	while(!TXIF)	/* set when register is empty */
		continue;
	TXREG = byte;
}

unsigned char 
usart_getch() {
	/* retrieve one byte */
	while(!RCIF)	/* set when register is not empty */
		continue;
	return RCREG;	
}

unsigned char
usart_getche(void)
{
	unsigned char c;
	putch(c = getch());
	return c;
}

