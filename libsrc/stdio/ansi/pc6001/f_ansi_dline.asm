;
;
; 	ANSI Video handling for the PC6001
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Jan 2013
;
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;


	PUBLIC	ansi_del_line

	;XREF	vram_addr


.ansi_del_line
	ld	l,1
	inc a
	ld	h,a
	CALL 11CDh      ; L2A - convert location to screen address
	push hl

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	pop hl

	ld	a,$E0
	and	h
	ld	h,a
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir

	ret
