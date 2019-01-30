
#ifndef __ARCH_PX8_H__
#define __ARCH_PX8_H__

#include <sys/types.h>

struct SUBCPU_PACKET {
	u16_t	sndpkt;	/* Pointer to packet data being sent     */
	u16_t	size;	/* Size of packet data being sent        */
	u16_t	rcvpkt;	/* Pointer to packet data being received */
	u16_t	bytes;	/* Size of packet data being received (+1 status byte) */
};

// Send a command to subcpu.
extern int __LIB__ subcpu_call(unsigned char *packet) __z88dk_fastcall;

#endif
