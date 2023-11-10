/*
 * Flush cache to disc
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <cpm.h>


int fsync(int fd)
{
    struct fcb *fc;

    if ( fd >= MAXFILE ) {
        // TODO: Set EBADF
        return -1;
    }

    fc = &_fcb[fd];

    switch ( fc->use ) {
    case U_WRITE:
    case U_RDWR:
        switch ( cpm_cache_flush(fc) ) {
        case -1: // Error
            // We couldn't write the sector to disc
            return -1;
        default:  // We did it, close and reopen the file
            bdos(CPM_CLS,fc);
            if ( bdos(CPM_OPN,fc) == -1 ) {
                // TODO: Set error
                return -1;
            }
        }
        return 0;
    }
    // TODO: Set EINVAL
    return -1;
}
