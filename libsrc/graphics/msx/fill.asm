;
;	MSX basic graphics routines
;	by Stefano Bodrato, December 2007
;   19/5/2014 - extended to Spectravideo SVI
;
;
;	$Id: fill.asm,v 1.5 2016-06-21 20:16:35 dom Exp $
;

;Usage: fill(struct *pixel)

	SECTION	  code_clib
        PUBLIC    fill
        PUBLIC    _fill

	INCLUDE	"graphics/grafix.inc"

	EXTERN	msxextrom

IF FORmsx
        INCLUDE "msxbasic.def"
		EXTERN	msxbasic
ELSE
        INCLUDE "svibasic.def"
		EXTERN	msxbios
ENDIF

	EXTERN	msx_breakoff
	EXTERN	msx_breakon


.fill
._fill
	push	ix		;save callers
	ld	ix,2
	add	ix,sp
	ld	a,(ix+2)
	cp	maxy       ;check range for y
	jr	nc, fill_exit

	ld	l,(ix+4)   ;x
	ld	h,0
	ld	d,h
	ld	e,a        ;y

	ld	(GRPACX),hl
	ld	(GRPACY),de
	push	hl
	push	de
	
	ld	a,fcolor
	ld	(ATRBYT),a		; set fill color
	ld	(BRDATR),a		; set border color

	;ld	hl,-2048
	;add	hl,sp
	
	;ld	(STREND),hl
	
	pop	de			; set y
	pop	bc			; set x

IF FORmsx
	call	msx_breakoff
	ld	a,(SCRMOD)
	cp	4+1
	jr	c,pnt_old
	ld	ix,N_PAINT
	call	msxextrom
	jr	pnt_done
pnt_old:
ELSE
	xor a
	ld (INTFLG),a
ENDIF

	ld	ix,O_PAINT

IF FORmsx
	call	msxbasic
pnt_done:
	call	msx_breakon
ELSE
	call	msxbios
ENDIF
.fill_exit
	pop	ix
	ret

