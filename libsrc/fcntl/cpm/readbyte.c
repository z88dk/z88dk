/*
 *  Read a single byte from a file
 *
 *  27/1/2002 - djm
 *
 *  $Id: readbyte.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <fcntl.h>



int readbyte(int fd)
{
    unsigned char  buffer;
    if ( read(fd,&buffer,1) == -1 )
	return -1;
    return buffer;
}
