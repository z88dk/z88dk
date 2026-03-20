/*
 *  Read from a file
 *
 *  27/1/2002 - djm
 *      HDOS version: Stefano, 2026
 *
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <arch/hdos.h>

extern void *_CPM_READ_CACHE_ALWAYS;
#define CPM_READ_CACHE_ALWAYS (int)&_CPM_READ_CACHE_ALWAYS

ssize_t read(int fd, void *buf, size_t len)
{
#ifdef DEVICES
    unsigned char buffer[SECSIZE+2];
#endif
    size_t cnt,size,offset;
    struct fcb *fc;


    fc = (struct fcb *) fd; 
    switch ( fc->use ) {
    case U_READ:
    case U_RDWR:
        cnt = len;

        if ( len == 1 ) {
            unsigned int record_nr = fc->record_nr;
            if ( fc->rnr_dirty ) { fc->record_nr = record_nr = fc->rwptr/SECSIZE; fc->rnr_dirty = 0; }
            offset = fc->rwptr%SECSIZE;

            if ( record_nr != fc->cached_record ) {
                if (hdos_cache_get(fc, record_nr, 1) ) {
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
                unsigned int record_nr = fc->record_nr;
                
                if ( fc->rnr_dirty ) { record_nr = fc->record_nr = fc->rwptr/SECSIZE; fc->rnr_dirty = 0; }
                offset = fc->rwptr%SECSIZE;

                if ( ( size = SECSIZE - offset ) > len ) {
                    size = len;
                }
                if ( size == SECSIZE && CPM_READ_CACHE_ALWAYS == 0 ) {
                    hdos_posit(fc->ch, record_nr);     // TODO: verify whether this one can be omitted
                    if ( !hdos_read(fc->ch,buf,256) ) {
                        return cnt-len;
                    }
                } else {
                    if ( record_nr != fc->cached_record ) {
                        if (hdos_cache_get(fc, record_nr, 1) ) {
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

