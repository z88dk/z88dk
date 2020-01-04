/*
 *      Tape load routine
 *
 *		tape_load_block(void *addr, size_t len, unsigned char type)
 * 
 *      Stefano, 2013
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sos.h>

char sos_ltmpname[7];

int tape_load_block(void *addr, size_t len, unsigned char type)
{
	itoa(addr,sos_ltmpname,16);
	sos_ltmpname[4]='.';
	itoa(type,sos_ltmpname+5,16);
	sos_ltmpname[6]=0;
	sos_file (sos_ltmpname,type);
	SOS_SIZE=len;
	SOS_DTADR=(unsigned int)addr;
	SOS_EXADR=SOS_HOT;	// So it won't harm if the user tries to run it
	
    if ( !sos_ropen() )
                return -1;
    if ( !sos_rdd() )
                return -1;
        return 0;
}
