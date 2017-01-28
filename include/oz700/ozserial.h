/* 
	HTC Compatibility Library and OZ extras 
	6. SERIAL PORT I/O

	$Id: ozserial.h,v 1.2 2016-06-28 17:11:31 dom Exp $
*/

#include <graphics.h>

#ifndef _OZSERIAL_H
#define _OZSERIAL_H

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

extern __LIB__ ozsnap(void);
extern byte __LIB__ ozgetrxhandshaking(void);
extern __LIB__ ozsetrxhandshaking(int state);
extern __LIB__ ozclearserialbuffer(void);
extern __LIB__ ozdatabits(int databits);
extern int __LIB__ ozserialgetc(void);
extern __LIB__ ozsetbaud(unsigned baud);
extern unsigned __LIB__ ozgetbaud(void);
extern __LIB__ ozstopbits(int stopbits);
extern __LIB__ ozparity(int parity);
extern byte __LIB__ ozgetlcr(void);
extern __LIB__ ozsetlcr(int lcr);
extern int __LIB__ ozserialin(void);
extern __LIB__ ozserialout(int c);
extern __LIB__ ozserinton(void);
//extern __LIB__ _ozserinton(void);
extern __LIB__ ozserintoff(void);
//extern __LIB__ _ozserintoff(void);
/* for ozparity() */
#define NO_PARITY 0
#define ODD_PARITY 0x08
#define EVEN_PARITY 0x18
#define HIGH_PARITY 0x28
#define LOW_PARITY	0x38

/* for ozstopbits() */
#define ONE_STOP_BIT 0
#define TWO_STOP_BITS 4
#define ONE_POINT_FIVE_STOP_BITS 4

/* for ozbaud() */
#define BAUD76800 2
#define BAUD51200 3
#define BAUD38400 4
#define BAUD30720 5
#define BAUD25600 6
#define BAUD19200 8
#define BAUD9600 16
#define BAUD4800 32
#define BAUD2400 64
#define BAUD1200 128
#define BAUD600 256
#define BAUD300 512
#define BAUD150 1024

/* for ozdatabits() */
#define DATABITS5 0
#define DATABITS6 1
#define DATABITS7 2
#define DATABITS8 3

/* for ozxxxlcr() */
#define BREAKSTATE 0x40

#endif
