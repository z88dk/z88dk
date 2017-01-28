/*
 * fopen.c - open a stream
 *
 * Vaguely, vaguely based upon K&R p177
 *
 * djm 4/5/99
 *
 * --------
 * $Id: fopen.c,v 1.4 2016-06-13 19:56:40 dom Exp $
 */

#define ANSI_STDIO

#include        <stdio.h>


FILE *
fopen(const char *name, const char *mode)
{
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk_end; ++fp) {
                if (fp->flags == 0 ) break;
	}

        if (fp >= _sgoioblk_end) {
		return NULL; /* No free slots */
	}


        return (freopen(name,mode,fp));
}


