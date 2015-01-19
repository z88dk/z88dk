;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2015-01-19 01:33:19 pauloscustodio Exp $
;


	PUBLIC	ansi_del_line

; a = line
.ansi_del_line
	ld	d,a		;y cooard
	ld	e,0		;x coord
	ld	h,1		;height
	ld	l,80		;width
	ld	b,7		;colour
	ld	a,0
	ld	c,$56		;CLEAR
	rst	$10
	ret
