/*
 *      Small C+ String Library
 *
 *	memchr(void *data, unsigned char byte, size_t count);
 *
 *	Search memory for a byte..
 *
 *	djm 22/12/99
 */

#include <string.h>


void *memchr(void *s,unsigned char c,int length)
{
    while(length--) if((unsigned char)*s==c) return(s); else s++;
    return(0);
}
