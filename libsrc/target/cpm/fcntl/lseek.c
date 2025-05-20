/*
 *    long lseek(int fd, long posn, int whence)
 *
 *    0    SEEK_SET from start of file
 *    1    SEEK_CUR from current position
 *    2    SEEK_END from end of file (always -ve)
 *
 *    $Id: lseek.c,v 1.6 2013-06-06 08:58:32 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

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
        bdos(CPM_CFS,fc); 
        pos = (unsigned long) (fc->ranrec[0] + 256 * fc->ranrec[1]) * 128L; 

        if (fc->ranrec[2]&1) 
            pos += 8388608L; 
        if ((fc->mode & _IOTEXT) && (pos >= 128)) { 
            do { 
                fc->rwptr = pos-128; 
                cnt=0; 
                if (read(fd, buffer, 128)!=-1) { 
                    while (cnt < 128 && buffer[127-cnt]==__STDIO_EOFMARKER) 
                        cnt++; 
                    pos -= cnt; 
                } 
            } while (cnt == 128 && pos >= 128); 
        } 
        pos = pos + posn; 
        break; 
    }

    if (pos < 0L)
        return -1L;
    
    fc->rwptr = pos;
    fc->rnr_dirty = 1;
    return pos;
    
}
