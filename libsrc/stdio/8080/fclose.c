/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fclose.c,v 1.1 2002-05-10 11:08:56 dom Exp $
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
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl,-1	;EOF
	inc	de
	inc	de
	ld	a,(de)	;de = &fp_flags
	dec	de
	dec	de	;de=&fp_desc
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
	ex	de,hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	dec	hl
	ex	de,hl	;de = &fp_desc hl = *fp_desc
	push	de
	push	hl
	call	closenet
	jr	ckclosed
.no_net
#endif
	push	de
	call	fchkstd
	pop	de
	jr	nc,is_closed	;was std* (def setup)
	ex	de,hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	dec	hl
	ex	de,hl	;de = &fp_desc hl = *fp_desc
	push	de
	push	hl
	call	close
.ckclosed
	pop	bc
	pop	de
	ld	a,h
	or	l
	ret	nz
.is_closed
	ex	de,hl
	ld	de,0
	ld	(hl),e	;fp_desc
	inc	hl
	ld	(hl),e	;fp_desc+1
	inc	hl
	ld	(hl),e	;fp_flags
	ex	de,hl	;hl = 0 = success
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
