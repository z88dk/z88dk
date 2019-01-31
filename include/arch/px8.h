
#ifndef __ARCH_PX8_H__
#define __ARCH_PX8_H__

#include <sys/types.h>

/* Useful only for subcpu_call(), which normally is called internally
   it is rather advisable to use subcpu_command() or subcpu_function() */

struct SUBCPU_MASTERPACKET {
	u16_t	sndpkt;	/* Pointer to packet data being sent     */
	u16_t	size;	/* Size of packet data being sent        */
	u16_t	rcvpkt;	/* Pointer to packet data being received */
	u16_t	bytes;	/* Size of packet data being received (+1 status byte) */
};


/* Slave CPU return codes */
#define SYS_OK		0		// SYS:  OK, normal termination
#define SYS_BREAK	1		// SYS:  Break acknowledged
#define SYS_ERROR	2		// SYS:  Command error
#define SYS_COMMS	3		// SYS:  Communication error
#define LCD_SIZE	11		// LCD:  Invalid size specification
#define LCD_UDG		12		// LCD:  Undefined graphics on UDG
#define LCD_CHAR	13		// LCD:  Invalid User Defined Graphics character
#define MCT_HEAD	41		// MCT:  Head error
#define MCT_STOP	42		// MCT:  Tape stopped during processing
#define MCT_WR_P	43		// MCT:  Write protection error
#define MCT_DATA	44		// MCT:  Data error
#define MCT_ERROR	45		// MCT:  CRC error
#define MCT_BLKMODE	46		// MCT:  Block mode error (invalid block identifier)
#define ESPS_OK			61		// ESPS: Linking unsuccessful
#define ESPS_ERROR		62		// ESPS: Communication error
#define ESPS_TIMEOUT	63		// ESPS: Time over
#define BEEP_ERROR		71		// BEEP: New BEEP or MELODY command while still playing


/* Macros for LCD*/
#define LCD_ON subcpu_command("\001\021\001")
#define LCD_OFF subcpu_command("\001\021\000")
#define LCD_TEXT subcpu_command("\001\022\001")
#define LCD_GRAPHICS subcpu_command("\001\022\000")
/* Macros for TEXT mode options*/
#define LCD_7LINES subcpu_command("\001\025\001")
#define LCD_8LINES subcpu_command("\001\025\000")


/* Talk to SUB-CPU via self-built packets. */
extern int __LIB__ subcpu_call(void *masterpacket) __z88dk_fastcall;

/* Send a command/parameters sequence to SUB-CPU where no data has to be sent back.
   The command sequence is: <parameters number>,<command code>,<parameter list>
   e.g. subcpu_command("\001\026\005"), or create char mycommand[]={1,0x12,5};*/
extern int __LIB__ subcpu_command(void *cmdsequence) __z88dk_fastcall;

/* Full communication with SUB-CPU, use structures to pass the whole parameter blocks and sizeof() for the *_sz part
 * 
 * (uses the parameters on stack, can't be converted to "CALLEE") */
extern int __LIB__ subcpu_function(int rcvpkt_sz, void *rcvpkt, int sndpkt_sz, void *sndpkt) __smallc;


#endif
