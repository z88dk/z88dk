/*
 *      Tape save routine
 *
 *
 *      djm 16/10/2001
 */

#define __HAVESEED
#include <stdlib.h>
#include <string.h>
#include <ace.h>

int tape_save(char *name, size_t loadstart,void *start, size_t len)
{
	struct  acetapehdr hdr;
	int	l,i;

	l = strlen(name);
	if ( l > 10 )
		l = 10;
	for (i=0 ; i < l ; i++ )
		hdr.name[i] = name[i];
	for ( ; i < 10 ; i++ )
		hdr.name[i] = 32;

	for (i=0 ; i < 10 ; i++ )
		hdr.name2[i] = 32;

        hdr.type    = 32;
        hdr.length  = len;
        hdr.address = loadstart;
        hdr.offset  = len;

        if ( tape_save_block(&hdr,26,0) )
                return -1;

        if ( tape_save_block(start,len,255) )
                return -1;
        return 0;
}
