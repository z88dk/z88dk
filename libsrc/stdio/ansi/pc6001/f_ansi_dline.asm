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
;	$Id: f_ansi_dline.asm,v 1.4 2016-07-14 17:44:18 pauloscustodio Exp $
;


        SECTION code_clib
	PUBLIC	ansi_del_line

	;EXTERN	vram_addr


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
