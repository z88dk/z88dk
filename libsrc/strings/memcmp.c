/*
 *       memcmp(void *s1, void *s2, size_t size)
 *
 *      djm 22/11/99
 *
 *	Let strncmp to all the hard work...
 */


#include <string.h>

#asm
.memcmp
	jp	strncmp
#endasm

