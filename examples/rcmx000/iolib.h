/*
	Z88DK - Rabbit Control Module examples

	Example I/O lib to use shadow registers in a unified way,
	in due time this should go into the rcmx000 library!

*/

/** This is indices to shadow registers and address lookup tables,
    not actual addresses */

#ifndef IOLIB__H
#define IOLIB__H


/* register "enum" */

/** New registers need to be added here and in iolib.c */
#define IOLIB_PADR 0
#define IOLIB_PEDR 1
#define IOLIB_PEDDR 2
#define IOLIB_SPCR 3
#define IOLIB_PGDR 4
#define IOLIB_PGCR 5
#define IOLIB_PGFR 6
#define IOLIB_PGDCR 7
#define IOLIB_PGDDR 8
#define IOLIB_RTC0R 9
#define IOLIB_PBDR 10
#define IOLIB_PBDDR 11

/** Returns physical io address of register */
extern unsigned iolib_physical(unsigned register);

/** Input one byte from reg */
extern unsigned char iolib_inb(unsigned register);

/** Output one byte to reg */
extern void iolib_outb(unsigned register, unsigned char data);

/** Set bit value (using shadow register) */
extern void iolib_setbit(unsigned register, unsigned char bit, unsigned char val);

/* Read bit from register */
extern unsigned char iolib_getbit(unsigned register, unsigned char bit);

#endif


