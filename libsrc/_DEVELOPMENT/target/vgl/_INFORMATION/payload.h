/*
	This is a bare API helper for vtech.h
	
	When compiling a payload, you don't want to statically include all the system functions of Penius Cheater AGAIN.
	Just include this file and use these proxy-methods that point to the system calls.
*/

#define byte unsigned char
#define word unsigned short
#define VAR_START_VTECH 0xc000

extern void *p_put	@ (VAR_START_VTECH + 0);
extern p_put_char	@ (VAR_START_VTECH + 2);

void put(byte *text) {
	p_put(text);
}
void put_char(byte c) {
	p_put_char(c);
}
