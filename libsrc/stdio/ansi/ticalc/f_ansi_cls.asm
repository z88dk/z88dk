;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Apr. 2000
;
; 	CLS - Clear the screen
;	

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

	XLIB	ansi_cls
	XREF	base_graphics
	XREF	cpygraph

.ansi_cls
  	ld	hl,(base_graphics)
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,row_bytes*64
	ldir
	jp	cpygraph
