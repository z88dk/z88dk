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
;	$Id: f_ansi_cls.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

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
