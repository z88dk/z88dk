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
;	$Id: f_ansi_dline.asm,v 1.4 2014-10-27 20:38:15 stefano Exp $
;


	XLIB	ansi_del_line
	XREF	base_graphics


.ansi_del_line
IF G007
	ld  h,0
	ld  e,a
	add a
	add a
	add a		; *8
	ld  l,a
	ld  a,e
	add	hl,hl	; *16
	add h
	ld	h,a		; *272
	ld	de,(base_graphics)
ELSE
	ld	d,a
	ld	e,0
	ld	hl,(base_graphics)
ENDIF
	add	hl,de	;Line address in HL
	
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
IF G007
	ld	bc,272
ELSE
	ld	bc,255
ENDIF
	ldir
	ret
