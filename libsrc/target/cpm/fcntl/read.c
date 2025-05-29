/*
 *  Read from a file
 *
 *  27/1/2002 - djm
 *
 *  May, 2020 - feilipu - added sequential read
 *  Apr, 2021 -dom - remove sequential read
 *  May, 2025 - feilipu - added sequential read (#2725) again
 *
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <cpm.h>
#include <stdio.h>

extern void *_CPM_READ_CACHE_ALWAYS;
#define CPM_READ_CACHE_ALWAYS (int)&_CPM_READ_CACHE_ALWAYS

ssize_t read(int fd, void *buf, size_t len)
{
    unsigned char buffer[SECSIZE+2];
    unsigned char uid;
    size_t cnt,size,offset;
    struct fcb *fc;


    fc = (struct fcb *) fd; 
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

        if ( len == 1 ) {
            unsigned long record_nr = fc->record_nr;
            if ( fc->rnr_dirty ) { fc->record_nr = record_nr = fc->rwptr/SECSIZE; fc->rnr_dirty = 0; }
            offset = fc->rwptr%SECSIZE;

            if ( record_nr != fc->cached_record ) {
                if ( cpm_cache_get(fc, record_nr, 1) ) {
                    return 0;
                }
            }
            *(uint8_t *)buf = fc->buffer[offset];
            ++fc->rwptr;
            if ( offset+1 == SECSIZE) {
                ++fc->record_nr;
            }
            return 1;
        } else {
            while ( len ) {
                unsigned long record_nr = fc->record_nr;

                if ( fc->rnr_dirty ) { record_nr = fc->record_nr = fc->rwptr/SECSIZE; fc->rnr_dirty = 0; }
                offset = fc->rwptr%SECSIZE;

                if ( ( size = SECSIZE - offset ) > len ) {
                    size = len;
                }

//              printf("RD - S2 %02x, EX %02x, CR %02x, cached_record %04lx, record_nr %04lx\n", (uint8_t)fc->s2, fc->extent, (uint8_t)fc->current_record, fc->cached_record, fc->record_nr);

                if ( size == SECSIZE && CPM_READ_CACHE_ALWAYS == 0 ) {
                    uid = swapuid(fc->uid);
                    setrecord(fc);
                    bdos(CPM_SDMA,buf);
                    if ( bdos(CPM_READ,fc) ) {
                        swapuid(uid);
                        return cnt-len;
                    }
                    swapuid(uid);
                } else {
                    if ( record_nr != fc->cached_record ) {
                        if ( cpm_cache_get(fc, record_nr, 1) ) {
                            return cnt-len;
                        }
                    }
                    if ( size == 1 ) {
                        *(uint8_t *)buf = fc->buffer[offset];
                    } else memcpy(buf,fc->buffer+offset,size);
                }
                buf += size;
                fc->rwptr += size;
                if ( size + offset == SECSIZE) {
                    ++fc->record_nr;
                }
                len -= size;
            }
        }
        return cnt-len;
        break;
    default:
        return -1;
        break;
    }
}

