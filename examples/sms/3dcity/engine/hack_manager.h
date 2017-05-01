#ifndef _HACK_MANAGER_H_
#define _HACK_MANAGER_H_

#define PEEK(addr)			(*(unsigned char *)(addr))
#define POKE(addr, data)	(*(unsigned char *)(addr) = (data))

#define HACKER_START		0x00C0

void engine_hack_manager_init();
void engine_hack_manager_invert();
void engine_hack_manager_resetX();

#endif//_HACK_MANAGER_H_
