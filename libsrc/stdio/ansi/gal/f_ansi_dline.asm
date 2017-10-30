;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm $
;


        SECTION code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	ld	hl,$2800
	and	a
	jr	z,isz
	ld	de,32
	ld	b,a
.gorow
	add	hl,de
	djnz	gorow
.isz
	ld	b,32
.filler
	ld	(hl),128
	inc	hl
	djnz	filler
	ret
