;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX 81
;
; 	Clean a text line
;
;	Stefano Bodrato - Sept. 2007
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2007-10-03 15:11:39 stefano Exp $
;


	XLIB	ansi_del_line
	XREF	base_graphics


.ansi_del_line
	ld	d,a
	ld	e,0
	ld	hl,(base_graphics)
	add	hl,de	;Line address in HL
	
	ld	(hl),e
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,255
	ldir
	ret
