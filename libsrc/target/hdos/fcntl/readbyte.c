/*
 *  Read a single byte from a file
 *
 *  27/1/2002 - djm
 *
 *  $Id: readbyte.c $
 */


#include <fcntl.h>



int readbyte(int fd)
{
    unsigned char  buffer;
    if ( read(fd,&buffer,1) != 1) {
        return_c -1;
    }
    return_nc buffer;
}
