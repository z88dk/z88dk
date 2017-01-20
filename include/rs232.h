/*
 * rs232.h
 *
 * RS232 prototypes for z88dk - not all machines supported!
 *
 * Based on the API from cc65
 *
 * $Id: rs232.h,v 1.4 2014-12-11 20:04:51 stefano Exp $
 */


#ifndef __RS232_H__
#define __RS232_H__

#include <sys/compiler.h>
#include <sys/types.h>

/* Baudrate settings */
#define RS_BAUD_50                      0x00
#define RS_BAUD_75                      0x01
#define RS_BAUD_110                     0x02
#define RS_BAUD_134_5                   0x03
#define RS_BAUD_150                     0x04
#define RS_BAUD_300                     0x05
#define RS_BAUD_600                     0x06
#define RS_BAUD_1200                    0x07
#define RS_BAUD_2400                    0x08
#define RS_BAUD_4800                    0x09
#define RS_BAUD_9600                    0x0A
#define RS_BAUD_19200                   0x0B
#define RS_BAUD_38400                   0x0C
#define RS_BAUD_57600                   0x0D
#define RS_BAUD_115200                  0x0E
#define RS_BAUD_230400                  0x0F

/* Stop bit settings */
#define RS_STOP_1                       0x00
#define RS_STOP_2                       0x80

/* Data bit settings */
#define RS_BITS_5                       0x60
#define RS_BITS_6                       0x40
#define RS_BITS_7                       0x20
#define RS_BITS_8                       0x00

/* Parity settings */
#define RS_PAR_NONE                     0x00
#define RS_PAR_ODD                      0x20
#define RS_PAR_EVEN                     0x60
#define RS_PAR_MARK                     0xA0
#define RS_PAR_SPACE                    0xE0


/* Error codes returned by all functions */
#define RS_ERR_OK                       0x00    /* Not an error - relax */
#define RS_ERR_NOT_INITIALIZED          0x01    /* Module not initialized */
#define RS_ERR_BAUD_TOO_FAST            0x02    /* Cannot handle baud rate */
#define RS_ERR_BAUD_NOT_AVAIL           0x03    /* Baud rate not available */
#define RS_ERR_NO_DATA                  0x04    /* Nothing to read */
#define RS_ERR_OVERFLOW                 0x05    /* No room in send buffer */


/* Handshaking codes used in XMODEM and its derivatives */

#define	SOH    1
#define	EOT    4
#define	ACK    6
#define	DLE    16
#define	DC1    17    /* X-On  */
#define	DC3    19    /* X-Off */
#define	NAK    21
#define	SYN    22
#define	CAN    24


/* The functions: Call params, then init then put/get finally close */


/* Set up the parameters for the serial interface use | of parameters above */
extern u8_t __LIB__ rs232_params(u8_t params,u8_t parity);

/* Initialise the serial interface */
extern u8_t __LIB__ rs232_init();

/* Close the interface */
extern u8_t __LIB__ rs232_close();


/* Write a byte to the serial interface */
extern u8_t  __LIB__ rs232_put(i8_t);


/* Read a byte from the serial, returns RS_ERR_NO_DATA if an error, places
   data in the pointer supplied
*/
extern u8_t  __LIB__ rs232_get(i8_t *);



#endif
