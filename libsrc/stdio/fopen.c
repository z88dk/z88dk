/*
 * fopen.c - open a stream
 *
 * Vaguely, vaguely based upon K&R p177
 *
 * djm 4/5/99
 *
 * --------
 * $Id: fopen.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO

#include        <stdio.h>


FILE *
fopen(far char *name, unsigned char *mode)
{
	char	buf[10];
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk+FOPEN_MAX ; ++fp) {
                if (fp->flags == 0 ) break;
	}

        if (fp >= _sgoioblk+FOPEN_MAX) return NULL; /* No free slots */


        return (freopen_z88(name,mode,fp,buf,9));
}


