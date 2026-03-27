/*
 *    long lseek(int fd, long posn, int whence)
 *
 *    0    SEEK_SET from start of file
 *    1    SEEK_CUR from current position
 *    2    SEEK_END from end of file (always -ve)
 *
 *    Stefano, Apr 2026
 *
 *    $Id: lseek.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <arch/hdos.h>

long lseek(int fd,long posn, int whence)
{
    struct fcb *fc = (struct fcb *)fd;
    long    pos;
    int     cnt;
    char    buffer[SECSIZE];

    switch(whence) {
    default:
        pos = posn;
        break;
    case 1:
        pos = fc->rwptr + posn;
        break;
    case 2:
        if ( (fc->use == U_WRITE || fc->use == U_RDWR) && fsync(fd) != 0 ) return -1L;

        // Quick and dirty simplification (bad approximation)
        while (readbyte(fd) != EOF) {};
        pos = fc->rwptr + posn;
        break; 
    }

    if (pos < 0L)
        return -1L;

    fc->rwptr = pos;
    fc->rnr_dirty = 1;
    return pos;
}
