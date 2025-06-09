/*
 *  Write to a file
 *
 *  27/1/2002 - djm
 *
 *  May, 2020 - feilipu - added sequential write
 *  Apr, 2021 - dom - remove sequential write 
 *  May, 2025 - feilipu - added sequential write (#2725) again
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <cpm.h>

/* Update the FCB to use WRITE #21 BDOS function non-sequentially */
void setrecord_wr(struct fcb *fc) __z88dk_fastcall;

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
                    fc->record_nr = record_nr;
                    uid = swapuid(fc->uid);
                    setrecord_wr(fc);
                    bdos(CPM_SDMA,buf);
                    if ( bdos(CPM_WRIT,fc) ) {
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

void setrecord_wr(struct fcb *fc) __z88dk_fastcall
{
    uint32_t record_nr = fc->record_nr;

    fc->current_record = (char)record_nr & 0x7F;

    fc->extent = (uint8_t)(record_nr >> 7) & 0x1F;

    fc->s2 &= 0x80;     // preserve the clean/dirty bit 7
    fc->s2 |= (char)(record_nr >> 12) & 0x0F;
}


