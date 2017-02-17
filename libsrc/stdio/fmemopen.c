

#include <stdio.h>


FILE *fmemopen(void *buf, size_t size, const char *mode)
{
        int     flags;
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk_end; ++fp) {
                if (fp->flags == 0 ) break;
        }

        if (fp >= _sgoioblk_end) {
                return NULL; /* No free slots */
        }
        switch (*(unsigned char *)mode) {
                case 'r':
                        flags=_IOREAD | _IOUSE| _IOTEXT | _IOSTRING;
                        break;
                case 'w':
                        flags = _IOWRITE | _IOUSE | _IOTEXT | _IOSTRING;
                        break;
                case 'a':
                        flags = _IOWRITE | _IOUSE | _IOTEXT | _IOSTRING;
                        break;
                default:
                        return NULL;
        }
#ifdef __STDIO_BINARY
        if ( *(unsigned char *) (mode+1) == 'b' )
            flags ^= _IOTEXT;
#endif
        fp->desc.ptr  = buf; 
        fp->flags = flags;
        fp->extra = size;
        return fp;
}

