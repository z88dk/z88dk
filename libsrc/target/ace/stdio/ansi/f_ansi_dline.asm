;
;
; 	ANSI Video handling for the Jupiter ACE
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Feb. 2001
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.5 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	ld	hl,$2400
.sum_loop
	ld	de,32
	add	hl,de
	dec	a
	jr	nz,sum_loop

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	ret
