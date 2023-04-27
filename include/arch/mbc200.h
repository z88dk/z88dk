#ifndef __ARCH_MBC200_H__
#define __ARCH_MBC200_H__

//////////////////////////
//   Video interface
//////////////////////////

// Send a byte to the video section
extern void __LIB__ mbc_sendchar(int chr)  __z88dk_fastcall;

// Smooth display scroll
extern void __LIB__ mbc_fade();

// Get a byte from the video section
extern int __LIB__ mbc_getbyte();

// Receive a little-endian word from the video section
extern unsigned int __LIB__ mbc_getword();


#endif
