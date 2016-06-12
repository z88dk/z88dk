;
; 	ANSI Video handling for the PC6001
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
	LD HL,0101h
	CALL 11CDh      ; L2A - convert location to screen address
	push hl
	ld	d,h
	ld	e,l
	inc	de
	
	ld	(hl),32

	ld	bc,511
	ldir

	pop hl
	ld	a,$f0
	and	h
	ld	h,a
	
	ld	d,h
	ld	e,l
	inc	de

	ld	(hl),0

	ld	bc,511
	ldir

	ret
