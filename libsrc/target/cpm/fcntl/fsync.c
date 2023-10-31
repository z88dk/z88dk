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
        cpm_cache_flush(fc);
        return 0;
    }
    // TODO: Set EINVAL
    return -1;
}
