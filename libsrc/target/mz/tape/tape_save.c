/*
 *      Tape save routine
 *
 *
 *      Stefano, 2022
 */

#define __HAVESEED
#include <stdlib.h>
#include <string.h>
#include <arch/mz.h>

int tape_save(char *name, size_t loadstart,void *start,void *exec,size_t len)
{
	struct  mztapehdr hdr;
	int	l,i;

	l = strlen(name);
	if ( l > 17 )
		l = 17;
	for (i=0 ; i < l ; i++ )
		hdr.name[i] = name[i];
	for ( ; i < 17 ; i++ )
		hdr.name[i] = 13;

// 01 machine code program file
// 03 MZ-80 data file
// 04 MZ-700 data file
        hdr.type    = 3;
        hdr.length  = len;
        hdr.address = loadstart;
        hdr.exec    = exec;

        if ( tape_save_block(&hdr,sizeof(hdr),0xCC) )
                return -1;

        if ( tape_save_block(start,len,0x53) )
                return -1;
        return 0;
}
