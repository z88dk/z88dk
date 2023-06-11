/*
 *      Tape save routine
 *
 *		tape_save_block(void *addr, size_t len, unsigned char type)
 * 
 *      Stefano, 2013
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sos.h>

char sos_stmpname[7];

int tape_save_block(void *addr, size_t len, unsigned char type)
{
	itoa(addr,sos_stmpname,16);
	sos_stmpname[4]='.';
	itoa(type,sos_stmpname+5,16);
	sos_stmpname[6]=0;
	sos_file (sos_stmpname,SOS_FILEATTR_BIN);
	SOS_SIZE=len;
	SOS_DTADR=(unsigned int)addr;
	SOS_EXADR=SOS_HOT;	// So it won't harm if the user tries to run it
	
    if ( !sos_wopen() )
                return -1;
    if ( !sos_wrd() )
                return -1;
        return 0;
}
