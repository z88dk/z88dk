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
    unsigned long    pos;
    int     cnt;
    char    buffer[SECSIZE];

    switch(whence) {
    case 1:
        pos = fc->rwptr + posn;
        break;
    case 2:
        if ( (fc->use == U_WRITE || fc->use == U_RDWR) && fsync(fd) != 0 ) return -1L;
		
		pos=(65535-hdos_posit(fc->ch,65535))*256L;

        if ((fc->mode & _IOTEXT) && (pos >= 256L)) { 
            do { 
                fc->rwptr = pos-256L;
                cnt=0; 
                if (read(fd, buffer, 256)!=-1) { 
                    while (cnt < 256 && buffer[255-cnt]==__STDIO_EOFMARKER) 
                        cnt++; 
                    pos -= (unsigned long)cnt; 
                } 
            } while (cnt == 256 && pos >= 256L); 
        }

        pos = pos + posn; 
        break;
    default:
        pos = posn;
        break;
    }

    if (pos < 0L)
        return -1L;

    fc->rwptr = pos;
    fc->rnr_dirty = 1;
    return pos;
}
