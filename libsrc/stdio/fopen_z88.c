/*
 * fopen.c - open a stream
 *
 * Vaguely, vaguely based upon K&R p177
 *
 * djm 4/5/99
 *
 */

#define ANSI_STDIO

#include        <stdio.h>


FILE *
fopen_z88(far char *name, unsigned char *mode, unsigned char *buf, size_t len)
{
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk+FOPEN_MAX ; ++fp)
                if (fp->flags == 0 ) break;


        if (fp >= _sgoioblk+FOPEN_MAX) return NULL; /* No free slots */

        return (freopen_z88(name,mode,fp,buf,len));
}


