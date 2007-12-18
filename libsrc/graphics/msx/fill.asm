;
;	MSX basic graphics routines
;	by Stefano Bodrato, December 2007
;
;
;	$Id: fill.asm,v 1.1 2007-12-18 09:00:43 stefano Exp $
;

;Usage: fill(struct *pixel)


        XLIB    fill

	INCLUDE	"graphics/grafix.inc"

	LIB	msxextrom
	LIB	msxbasic
        INCLUDE "#msxbasic.def"

	LIB	msx_breakoff
	LIB	msx_breakon


.fill
	ld	ix,0
	add	ix,sp
	ld	a,(ix+2)
	cp	maxy       ;check range for y
	ret	nc

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

	call	msx_breakoff

	ld	a,(SCRMOD)
	cp	4+1
	jr	c,pnt_old
	ld	ix,N_PAINT
	call	msxextrom
	jr	pnt_done
pnt_old:
	ld	ix,O_PAINT
	call	msxbasic
pnt_done:

	jp	msx_breakon
