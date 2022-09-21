/*
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: rnd_saveblock.c $
;
*/

#define __HAVESEED
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sos.h>

int rnd_saveblock(char *name,void *pos, unsigned int len) {
	sos_file (name,SOS_FILEATTR_BIN);
	SOS_SIZE=len;
	SOS_DTADR=(unsigned int)pos;
	SOS_EXADR=SOS_HOT;
	
    //if ( !sos_wopen() )
    //            return -1;
    sos_wopen();
/*
	SOS_SIZE=len;
	SOS_DTADR=pos;
	SOS_EXADR=SOS_HOT;
*/
    if ( !sos_wrd() )
                return -1;
	return (0);

}
