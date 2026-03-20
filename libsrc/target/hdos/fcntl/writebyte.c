/*
 *  Write a single byte to disc
 *
 *  27/1/2002 - djm
 *  HDOS version: Stefano, 2026
 *
 *  $Id: writebyte.c $
 */


#include <fcntl.h>



int writebyte(int fd, int byte)
{
    return ( write(fd,&byte,1) );
}
