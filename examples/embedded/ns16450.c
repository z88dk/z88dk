#include "ns16450.h"

extern void init_uart(unsigned char DM, unsigned char DL)
{
	output8(UART_BASE + LCR, 0x80);	/* DLAB = 1 */
	output8(UART_BASE + DLL, DL);
	output8(UART_BASE + DLM, DM);
	output8(UART_BASE + LCR, 0x03);	/* N81 */
}
