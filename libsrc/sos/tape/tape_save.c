/*
 *      Tape save routine
 *
 *
 *      Stefano, 2013
 */

#define __HAVESEED
#include <stdlib.h>
#include <string.h>
#include <sos.h>

int tape_save(char *name, size_t loadstart,void *start, size_t len)
{
	sos_file (name,SOS_FILEATTR_BIN);
	SOS_SIZE=len;
	SOS_DTADR=loadstart;
	SOS_EXADR=SOS_HOT;	// So it won't harm if the user tries to run it
	
    if ( !sos_wopen() )
                return -1;
    if ( !sos_wrd() )
                return -1;
        return 0;
}
