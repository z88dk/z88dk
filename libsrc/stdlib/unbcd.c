/*
 *	Decode from BCD to unsigned int
 *
 *	$Id: unbcd.c,v 1.1 2013-11-13 20:56:44 stefano Exp $
 */
#include <stdlib.h>

unsigned int unbcd(unsigned int value) {
	return ( ((value >> 16)&15) * 1000 + ((value >> 12)&15) * 100 + ((value >> 4)&15) * 10 + (value & 15) );
}
