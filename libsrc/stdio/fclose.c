/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ fclose(FILE *fp)
{
#ifdef Z80
#asm
	pop	de
	pop	ix
	push	ix
	push	de
	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)
	ld	c,a
	and	_IOUSE	;is it defined
	ret	z	;no
	ld	a,c
	and	_IOSTRING	;string?
	jr	nz,is_closed	;yes
#ifdef NET_STDIO
	ld	a,c
	and	_IONETWORK
	jr	z,no_net
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
	push	hl
	call	closenet
	jr	ckclosed
.no_net
#endif
	push	ix
	call	fchkstd
	pop	ix
	jr	nc,is_closed	;was std* (def setup)
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
	push	hl
	call	close
.ckclosed
	pop	bc
	pop	ix
	ld	a,h
	or	l
	ret	nz
.is_closed
	ld	hl,0
	ld	(ix+fp_flags),l
	ld	(ix+fp_desc),l
	ld	(ix+fp_desc+1),h
#endasm
#else
        if ( (fp->flags&_IOUSE ==0 )  ||  (fp->flags&_IOSTRING) )  return(EOF);

	if (fchkstd(fp) == 0 ) {
		if (close(fp->desc.fd) ) return EOF;
	}
	fp->desc.fd=0;
	fp->flags=0;
	return 0;
#endif
}
