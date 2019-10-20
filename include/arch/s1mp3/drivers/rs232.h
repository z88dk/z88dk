

#ifndef __RS232_H__
#define __RS232_H__


#define RS232_BUFFERSIZE 0x100     /*Must be power of 2 */

#define RS232_BUFFERMASK (RS232_BUFFERSIZE - 1)
#if (RS232_BUFFERSIZE ^ RS232_BUFFERMASK) != RS232_BUFFERSIZE * 2 - 1
#error RS232_BUFFERSIZE not 2 ** n
#endif

#define CTRLS   0x13
#define CTRLQ   0x11

#define RS232_NUMPORTS 1



typedef struct port_info_t
{
    unsigned char   port;
    unsigned char   ctrlSrx;
    unsigned char   ctrlSen;
//	unsigned char   rts_mode;
//	unsigned char   cts_observe;
    unsigned char   enabled;
	int input_insert;
	int input_remove;
	int output_insert;
	int output_remove;
    unsigned char     output_buffer[RS232_BUFFERSIZE];
    unsigned char     input_buffer[RS232_BUFFERSIZE];
//    long      msg_start_gap;
//    unsigned int    msg_start_index;
//    int             tx_idle_mode;
    unsigned int    PortBaudRate;
} port_info_s;


/* Init/ISR */
extern unsigned char __LIB__ RS232_Initialise( void );
extern void __LIB__ RS232_isr( void );

/* Read char */
extern int __LIB__ RS232_Anychar( void );
extern unsigned char __LIB__ RS232_Getchar( void );

/* Write char(s) */
extern void __LIB__ RS232_Putchar( unsigned char c );
extern void __LIB__ RS232_Putstring( unsigned char *string, unsigned char length ) __smallc;
extern void __LIB__ RS232_Putstring_Null( unsigned char *string );

#endif

