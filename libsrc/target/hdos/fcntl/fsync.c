/*
 * Flush cache to disc
 * Stefano, 2026
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <arch/hdos.h>


int fsync(int fd)
{
    struct fcb *fc = (struct fcb *)fd;


    switch ( fc->use ) {
    case U_WRITE:
    case U_RDWR:
        fc->dirty=1;   // Force a cache write (just in case)
        if ( hdos_cache_flush(fc) )
            // We couldn't write the sector to disc
            return -1;
        return 0;
    }
    // TODO: Set EINVAL
    return -1;
}
