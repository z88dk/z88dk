/*
 *	Read from a file
 *
 *	int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls read() in fcntl to do the dirty work
 *
 *	Returns number of members readen
 *
 *	We have to take account of ungotten characters
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fread.c,v 1.7 2010-01-15 07:12:05 stefano Exp $
 */

#define ANSI_STDIO
#define STDIO_ASM
#include <stdio.h>

static int fread1(void *ptr, size_t len, FILE *fp) __z88dk_callee;

int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOREAD)==(_IOUSE|_IOREAD))  && 
			fchkstd(fp)== 0) {
		int	readen = size*nmemb;
		int     count  = 0;
#ifdef __STDIO_BINARY
		while ( count < readen ) {
		    int c = fgetc(fp);
		    if ( c == EOF ) {
			break;
		    }
		    *ptr++ = (unsigned char)c;
		    ++count;
		}
		return ( count / size );  /* Relies on 0 / x != EXCEPTION */
#else			
		if (readen) {
		    /* Pick up ungot character */
		    int c = fgetc(fp);
		    /* Horrible hack around here */
		    if ( c >= 0 ) {
			*ptr = (unsigned char )c;
			readen=fread1(ptr+1,readen-1,fp);
			++readen;
			/* Return number of members read */
			return (readen/size);
		    }
		}
#endif
	}
	return 0;
}


#ifndef __STDIO_BINARY

#asm
; (buf, size, fp)
_fread1:
        pop     hl
        pop     ix              ;fp
        pop     bc              ;size
        pop     de              ;buf
        push    hl              ;restore return address
        ld      a,(ix+fp_flags)
        and     _IOEXTRA
        jr      z,fread_direct
        ; Calling via the extra hook
        ld      l,(ix+fp_extra)
        ld      h,(ix+fp_extra+1)
        ld      a,__STDIO_MSG_READ
        jp      l_jphl
fread_direct:
        ld      l,(ix+fp_desc)
        ld      h,(ix+fp_desc+1)
        push    hl
        push    de
        push    bc
        call    read
        pop     bc
        pop     bc
        pop     bc
        ret
#endasm
#endif

