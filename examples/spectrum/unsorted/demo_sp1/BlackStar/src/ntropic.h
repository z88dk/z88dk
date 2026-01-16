#ifndef _NTROPIC_H
#define _NTROPIC_H

// loop 0 for no loop, anything else will loop, use callee linkage
extern void ntropic_play(unsigned char *song_addr, unsigned int loop) __z88dk_callee;

#endif
