/*
 *  Write to a file
 *
 *  27/1/2002 - djm
 *
 *  May, 2020 - feilipu - added sequential write
 *  Apr, 2021 - dom - remove sequential write 
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <cpm.h>


ssize_t write(int fd, void *buf, size_t len)
{
    unsigned char buffer[SECSIZE+2];
    unsigned char uid;
    struct fcb *fc;
    size_t cnt,size,offset;

    if ( fd >= MAXFILE )
    return -1;

    fc = &_fcb[fd];
    cnt = len;
    offset = CPM_WCON;  /* Double use of variable */

    switch ( fc->use ) {
#ifdef DEVICES
    case U_PUN:
        while ( len-- ) {
            bdos(CPM_WPUN,*buf++);
        }
        return cnt;
        break;
    case U_LST:
        offset = CPM_WLST;
    case U_CON:
        while ( len-- ) {
            bdos(offset,*buf++);
        }
        return cnt;
        break;
#endif
    case U_WRITE:
    case U_RDWR:
        uid = swapuid(fc->uid);
        while ( len ) {
            unsigned long record_nr = fc->rwptr/SECSIZE;
            offset = fc->rwptr%SECSIZE;
            if ( (size = SECSIZE-offset) > len ) {
                size = len;
            }
            if ( size == SECSIZE ) {
                // Write the full sector now, flush whatever we've got cached so we don't 
                // write out of order
                cpm_cache_flush(fc);

                _putoffset(fc->ranrec,fc->rwptr/SECSIZE);
                bdos(CPM_SDMA,buf);
                if ( bdos(CPM_WRAN,fc) ) {
                    swapuid(uid);
                    return cnt-len;
                }
            } else {  /* Not the required size, read in the record to our cache */
                if ( cpm_cache_get(fc, record_nr, 0) == - 1 ) {
                    swapuid(uid);
                    return cnt-len;
                }
                memcpy(fc->buffer+offset,buf,size);
                fc->dirty = 1;
            }
            buf += size;
            fc->rwptr += size;
            len -= size;
        }
        swapuid(uid);
        return cnt-len;
        break;
    default:
        return -1;
        break;
    }
}

