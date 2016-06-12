;
;
; 	ANSI Video handling for the Sharp MZ
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Maj 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;


        SECTION code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	ret
	ld	hl,$D000
.sum_loop
	ld	de,40
	add	hl,de
	dec	a
	jr	nz,sum_loop

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ldir
	ret
