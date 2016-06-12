;
;       Sprinter C Library
;
; 	ANSI Video handling for ZX Sprinter
;
; 	Clean a text line
;
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
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
