;
; 	ANSI Video handling
;	Non optimized (but generic) code
;
; 	Clean a text line
;
;	Stefano Bodrato - 2014
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line_generic

	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	__console_w

	EXTERN	ansi_CHAR

.ansi_del_line_generic

	ld	e,a
	ld	a,(__console_y)
	push af
	
	ld	a,e
	ld  (__console_y),a

	ld	a,(__console_w)
	ld  b,a

.rloop
	ld	a,b
	dec a
	ld  (__console_x),a
	push bc
	ld   a,' '
	call ansi_CHAR
	pop  bc
	djnz rloop

	pop	af
	ld  (__console_y),a
	
	ret
