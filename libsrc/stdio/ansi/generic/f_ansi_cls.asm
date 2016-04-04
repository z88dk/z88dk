;
; 	ANSI Video handling
;	Non optimized (but generic) code
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

	SECTION  code_clib
	PUBLIC	ansi_cls

	EXTERN		ansi_del_line

	EXTERN	text_rows

.ansi_cls
	ld a,(text_rows)
	ld b,a

.clsloop
	push bc
	ld	a,b
	dec a
	call	ansi_del_line
	pop bc
	djnz clsloop

	ret
