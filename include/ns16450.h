/*
    UART definitions

    Daniel Wallner - Feb. 2002
 */

#define UART_BASE 0x0000

#define RBR 0
#define THR 0
#define IER 1
#define IIR 2
#define LCR 3
#define MCR 4
#define LSR 5
#define MSR 6
#define SCR 7
#define DLL 0
#define DLM 1

extern void __LIB__ output8(unsigned short addr, unsigned char data);

extern void init_uart(unsigned char DM, unsigned char DL);
