;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Dec. 2000
;
;	Scrollup
;

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

	XLIB	ansi_SCROLLUP
	XREF	base_graphics
	LIB	ansi_del_line
	LIB	fgetc_cons

.ansi_SCROLLUP

IF FORti82
; This is called before scrolling: we wait for any keypress
.kloop
	;halt	; Power saving (?? maybe. It worked on ti86)
	ld	hl,$8004
	bit	2,(hl)
	jr	z,kloop
ELSE
; We use getkey to wait for a key
.kloop
	call	getkey
	and	a
	jr	z,kloop
ENDIF

  	ld	hl,8*row_bytes
  	ld	de,(base_graphics)
	add	hl,de
	ld	bc,row_bytes*8*7
	ldir
	
	ld	a,7
	jp	ansi_del_line
