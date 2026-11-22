

#include <cpm.h>
#include <string.h>

int cpm_cache_get(struct fcb *fcb, unsigned long record_nr, int for_read)
{
    int uid;
    // We've already got it cached, just use it - check done in read/write
    //if ( record_nr == fcb->cached_record ) return 0;

    if ( cpm_cache_flush(fcb) == -1 ) return -1;

    uid = swapuid(fcb->uid);

    fcb->cached_record = 0xffffffff;
    _putoffset(fcb->ranrec,record_nr);
    bdos(CPM_SDMA,fcb->buffer);
    if ( bdos(CPM_RRAN,fcb) ) {
        swapuid(uid);
        if ( for_read ) return -1;
        // It's for a write, unknown sector, fill with EOF marker
        memset(fcb->buffer, 26, SECSIZE);
    }
    swapuid(uid);
    fcb->cached_record = record_nr;
    return 0;
}

/**
 * \retval 0 = Nothing to do
 * \retval 1 = Flushed cache
 * \retval -1 = Error flushing
 */
int cpm_cache_flush(struct fcb *fcb)
{
    int uid;

    if ( fcb->dirty ) {
        _putoffset(fcb->ranrec,fcb->cached_record);
        uid = swapuid(fcb->uid);
        bdos(CPM_SDMA,fcb->buffer);
        if ( bdos(CPM_WRAN,fcb) == 0 ) {
            swapuid(uid);
            fcb->dirty = 0;
            return 1;
        }
        swapuid(uid);
        return -1;
    }
    return 0;
}
