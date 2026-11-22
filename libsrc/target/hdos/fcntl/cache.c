/*
 *  HDOS version: Stefano, 2026
 *
 */

#include <arch/hdos.h>
#include <string.h>

int hdos_cache_get(struct fcb *fcb, uint16_t record_nr, int for_read)
{
    // We've already got it cached, just use it - check done in read/write
    if ( record_nr == fcb->cached_record ) return 0;
    if ( hdos_cache_flush(fcb) == -1 ) return -1;

    fcb->cached_record = 0xffff;
    hdos_posit(fcb->ch, record_nr);
    if ( hdos_read(fcb->ch,fcb->buffer,256) ) {
        if ( for_read ) return -1;
        // It's for a write, unknown sector, fill with EOF marker
        memset(fcb->buffer, 26, SECSIZE);
    }
    fcb->cached_record = record_nr;
    return 0;
}

/**
 * \retval 0 = Nothing to do
 * \retval 1 = Flushed cache
 * \retval -1 = Error flushing
 */
int hdos_cache_flush(struct fcb *fcb)
{

    if ( fcb->dirty ) {
        hdos_posit(fcb->ch, fcb->cached_record);
        if ( hdos_write(fcb->ch,fcb->buffer,256)  == 0 ) {
            fcb->dirty = 0;
            return 1;
        }
        return -1;
    }
    return 0;
}
