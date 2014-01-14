/*
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: rnd_loadblock.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
;
*/

#define __HAVESEED
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sos.h>

int rnd_loadblock(char *name,unsigned int pos, unsigned int len) {
	sos_file (name,SOS_FILEATTR_BIN);
	SOS_SIZE=len;
	SOS_DTADR=pos;
	SOS_EXADR=SOS_HOT;
	
    //if ( !sos_ropen() )
    //            return -1;
	sos_ropen();
/*
	SOS_SIZE=len;
	SOS_DTADR=pos;
	SOS_EXADR=SOS_HOT;
*/
    if ( !sos_rdd() )
                return -1;
	return (0);

}
