;
; long fdtell(int fd, long posn, int whence)
;
; Set position in file
;
; Not written as yet!
;
; $Id: lseek.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $

		SECTION	code_clib
		PUBLIC	lseek	
		PUBLIC   _lseek

		EXTERN	l_long_add
		EXTERN	l_long_sub
		EXTERN	dodos

                INCLUDE "target/zx/def/p3dos.def"

.lseek
._lseek
	push	ix		;save callers
	ld	ix,4
	add	ix,sp
	ld	a,(ix+0)	;whence
	and	a
	jr	z,set_posn
	dec	a
	jr	z,relative
	dec	a
	jr	nz,error
	; from end		
	ld	b,(ix+6)
	push	ix
	ld	ix, DOS_GET_EOF 
	call	dodos
	pop	ix
	jr	nc,error
	push	de
	push	hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	e,(ix+4)
IF !idedos
	ld	d,0
ENDIF
	call	l_long_sub
	jr	do_seek

.relative
	ld	b,(ix+6)
	push	ix
	ld	ix, DOS_GET_POSITION
	call	dodos
	pop	ix
	jr	nc,error
IF !idedos
	ld	d,0
ENDIF
	push	de
	push	hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	e,(ix+4)
	ld	d,(ix+5)
	call	l_long_add
	jr	do_seek
	
.set_posn
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	e,(ix+4)
.do_seek
	push	ix		;save our feame
	ld	b,(ix+6)
	ld	ix,DOS_SET_POSITION
	call	dodos
	pop	ix		;get our frame back
	jr	nc,error
	ld	b,(ix+6)
	ld	ix, DOS_GET_POSITION
	call	dodos
IF !idedos
	ld	d,0
ENDIF
	jr	nc,error
	pop	ix		;restore callers
	ret
	

.error
	ld	hl,-1
	ld	d,h
	ld	e,l
	pop	ix		;restore callers
	ret
