/*
 *	Write to a file
 *
 *	int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls write() in fcntl to do the dirty work
 *
 *	Returns number of members written
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fwrite.c,v 1.5 2012-06-13 11:04:30 stefano Exp $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>


static int fwrite1(void *ptr, size_t len, FILE *fp) __z88dk_callee;

int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOWRITE)==(_IOUSE|_IOWRITE)) && fchkstd(fp)== 0 ) {
		int written=fwrite1(ptr,size*nmemb,fp);
		/* Return number of members written */
		return (written/size);
	}
	return 0;
}

#asm
; (buf, size, fp)
_fwrite1:
	pop	hl
	pop	ix		;fp
	pop	bc		;size
	pop	de		;buf
        push	hl		;restore return address
	ld	a,(ix+fp_flags)
	and	_IOEXTRA
	jr	z,fwrite_direct
	; Calling via the extra hook
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
	ld	a,__STDIO_MSG_WRITE
	jp	l_jphl
fwrite_direct:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	push	de
	push	bc
	call	write
	pop	bc
	pop	bc	
	pop	bc	
	ret
#endasm
