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

	EXTERN	generic_console_printc


.ansi_del_line
	ld	b,a
	ld	c,0
	ld	a,32
loop:
	push	af
	push	bc
	ld	a,' '
	ld	e,0
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,loop
	ret
