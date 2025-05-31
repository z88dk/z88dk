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
    unsigned char uid;
    size_t cnt,size,offset;
    struct fcb *fc;


    fc = (struct fcb *) fd; 
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
        if ( len == 1 ) {
            unsigned long record_nr = fc->record_nr;
                
            if ( fc->rnr_dirty ) { record_nr = fc->record_nr = fc->rwptr/SECSIZE; fc->rnr_dirty = 0; }
            offset = fc->rwptr%SECSIZE;

             if ( record_nr != fc->cached_record ) {
                if ( cpm_cache_get(fc, record_nr, 0) == - 1 ) {
                    return 0;
                }
            }
            fc->dirty = 1;
            fc->buffer[offset] = *((uint8_t *)buf); 
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
                if ( (size = SECSIZE-offset) > len ) {
                    size = len;
                }
                if ( size == SECSIZE ) {
                    // Write the full sector now, flush whatever we've got cached so we don't 
                    // write out of order
                    cpm_cache_flush(fc);

                    _putoffset(fc->ranrec,fc->rwptr/SECSIZE);
                    uid = swapuid(fc->uid);
                    bdos(CPM_SDMA,buf);
                    if ( bdos(CPM_WRAN,fc) ) {
                        swapuid(uid);
                        return cnt-len;
                    }
                    swapuid(uid);
                } else {  /* Not the required size, read in the record to our cache */
                    if ( record_nr != fc->cached_record ) {
                        if ( cpm_cache_get(fc, record_nr, 0) == - 1 ) {
                            return cnt-len;
                        }
                    }
                    fc->dirty = 1;
                    if ( size == 1 ) fc->buffer[offset] = *((uint8_t *)buf); 
                    else memcpy(fc->buffer+offset,buf,size);
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

