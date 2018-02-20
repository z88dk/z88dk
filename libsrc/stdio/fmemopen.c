

#include <stdio.h>


FILE *fmemopen(void *buf, size_t size, const char *mode)
{
        int     flags;
        FILE    *fp = fdopen(0, mode);

        if ( fp != NULL ) {
            fp->flags |= _IOSTRING;
            fp->desc.ptr  = buf; 
            fp->extra = size;
        }
        return fp;
}

