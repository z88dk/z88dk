/*
 * Generic z88dk C Library: closeall()
 *
 * Closeall openfiles (called by startup code on exit)
 *
 * We try to fclose, if that fails we abandon them (machine
 * specific routine - z88 don't have one, +3 does)
 *
 * djm 1/4/2000
 *
 */

#define ANSI_STDIO

#include        <stdio.h>


void closeall(void)
{
        FILE    *fp;

        for (fp= _sgoioblk; fp < _sgoioblk+FOPEN_MAX ; ++fp) {
                if (fp->flags) {
			if ( fclose(fp) ) fabandon(fp);
		}
	}
}


