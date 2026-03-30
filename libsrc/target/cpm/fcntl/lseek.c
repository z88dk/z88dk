/*
 *    long lseek(int fd, long posn, int whence)
 *
 *    0    SEEK_SET from start of file
 *    1    SEEK_CUR from current position
 *    2    SEEK_END from end of file (always -ve)
 *
 *    $Id: lseek.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

long lseek(int fd,long posn, int whence)
{
    struct fcb *fc = (struct fcb *)fd;
    unsigned long    pos;
    int     cnt;
    char    buffer[SECSIZE];

    switch(whence) {
    case 0:
        pos = fc->rwptr + posn;
        break;
    case 1:
        pos = fc->rwptr + posn;
        break;
    case 2:
        if ( (fc->use == U_WRITE || fc->use == U_RDWR) && fsync(fd) != 0 ) return -1L;
        bdos(CPM_CFS,fc); 
        pos = (unsigned long) (fc->ranrec[0] + 256 * fc->ranrec[1]) * 128L; 

        if (fc->ranrec[2]&1) 
            pos += 8388608L; 
        if ((fc->mode & _IOTEXT) && (pos >= 128L)) { 
            do { 
                fc->rwptr = pos-128L; 
                cnt=0; 
                if (read(fd, buffer, 128)!=-1) { 
                    while (cnt < 128 && buffer[127-cnt]==__STDIO_EOFMARKER) 
                        cnt++; 
                    pos -= (unsigned long)cnt; 
                } 
            } while (cnt == 128 && pos >= 128L); 
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
