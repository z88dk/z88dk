/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fgets.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

char *fgets(unsigned char *s,int n,FILE *f)
{
    unsigned char *p=s;
    int	k=0;
    if(n<=0) return s;
    if (fchkstd(f) == -1 ) {	/* i.e. stdin */
	    return(fgets_cons(s,n));
    }
    while (--n) {
/* Handle those annoying CR/LF conventions */
	if (k=='\n' || k=='\r') break;
	k=fgetc(f);
        if(k==EOF) break;
        *p++=(char)k;
    }
    *p=0;
    if (k==EOF) return 0;
    return s;
}
