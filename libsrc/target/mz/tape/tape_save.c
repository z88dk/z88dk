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
	//struct  mztapehdr mz_hdr;
	int	l,i;

	l = strlen(name);
	if ( l > 17 )
		l = 17;
	for (i=0 ; i < l ; i++ )
		mz_hdr.name[i] = name[i];
	for ( ; i < 17 ; i++ )
		mz_hdr.name[i] = 13;

// 01 machine code program file
// 03 MZ-80 data file
// 04 MZ-700 data file
        mz_hdr.type    = 3;
        mz_hdr.length  = len;
        mz_hdr.address = loadstart;
        mz_hdr.exec    = exec;

        if ( mztape_save_header(0x10F0,128) )
                return -1;

        if ( mztape_save_block(start,len) )
                return -1;
        return 0;
}
