/*
 *  Read from a file
 *
 *  27/1/2002 - djm
 *
 *  May, 2020 - feilipu - added sequential read
 *  Apr, 2021 -dom - remove sequential read
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <cpm.h>


ssize_t read(int fd, void *buf, size_t len)
{
    unsigned char buffer[SECSIZE+2];
    unsigned char uid;
    struct fcb *fc;
    size_t cnt,size,offset;

    if ( fd >= MAXFILE )
       return -1;
    fc = &_fcb[fd];
    switch ( fc->use ) {
#ifdef DEVICES
    case U_RDR:         /* Reader device */
        cnt = len;
        while( len ) {
            len--;
            if((*buf++ = (bdos(CPM_RRDR,0xFF) & 0x7f)) == '\n')
                break;
        }
        return cnt - len;
        break;
    case U_CON:
       if( len > SECSIZE)
           len = SECSIZE;
       buffer[0] = len;
       bdos(CPM_RCOB, buffer);
       cnt = buffer[1];
       if(cnt < len) {
           bdos(CPM_WCON, '\n');
           buffer[cnt+2] = '\n';
           cnt++;
       }
       memcpy(buf,&buffer[2], cnt);
       return cnt;
       break;
#endif
    case U_READ:
    case U_RDWR:
        cnt = len;
        uid = swapuid(fc->uid);
        while ( len ) {
            unsigned long record_nr = fc->rwptr/SECSIZE;
            offset = fc->rwptr%SECSIZE;
            if ( ( size = SECSIZE - offset ) > len ) {
                size = len;
            }
            _putoffset(fc->ranrec,record_nr);
            if ( size == SECSIZE ) {
                bdos(CPM_SDMA,buf);
                if ( bdos(CPM_RRAN,fc) ) {
                    swapuid(uid);
                    return cnt-len;
                }
            } else {
                if ( cpm_cache_get(fc, record_nr, 1) ) {
                    swapuid(uid);
                    return cnt-len;
                }
                memcpy(buf,fc->buffer+offset,size);
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

