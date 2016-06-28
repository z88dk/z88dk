;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	void ozscrollclear();
;
; ------
; $Id: ozscrollclear.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozscrollclear
	PUBLIC	_ozscrollclear
	
	EXTERN	ozactivepage
	

ozscrollclear:
_ozscrollclear:
	in	a,(3)
	ld	c,a
	in	a,(4)
	ld	b,a
	push	bc

        ld      bc,(ozactivepage)
	ld	a,c
	out	(3),a
	ld	a,b
	out	(4),a

	ld	hl,0a000h+300
	ld	de,0a000h
	ld	bc,2400-300
	ldir
	ld	de,300
	xor	a
	ld	e,a
	ld	hl,0a000h+2400-300
	ld	bc,300
rpt:
	ld	(hl),e
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,rpt

	pop	bc

	ld	a,c
	out	(3),a
	ld	a,b
	out	(4),a
	ret



