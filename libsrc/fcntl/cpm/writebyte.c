/*
 *  Write a single byte to disc
 *
 *  27/1/2002 - djm
 *
 *  $Id: writebyte.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <fcntl.h>



int writebyte(int fd, int byte)
{
    return ( write(fd,&byte,1) );
}
