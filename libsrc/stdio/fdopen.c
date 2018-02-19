/*
 *	Associate a file handle with a stream
 *
 *	20/4/2000 djm
 *
 * --------
 * $Id: fdopen.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#include <stdio.h>


FILE *fdopen(int fildes, const char *mode)
{
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk_end; ++fp)
                if (fp->flags == 0 ) break;


        if (fp >= _sgoioblk_end) return NULL; /* No free slots */

        return _freopen1(NULL, fildes, mode, fp);
}
