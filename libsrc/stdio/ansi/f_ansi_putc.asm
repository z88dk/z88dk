;
;       Z80 ANSI Library
;
;---------------------------------------------------
;      Character output
;      x,y coordinates and LineFeed handling
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: f_ansi_putc.asm,v 1.3 2013-07-22 09:37:39 stefano Exp $
;

	XLIB	ansi_putc

	XREF	ansi_COLUMN

	XREF	text_cols

	LIB	ansi_CHAR
	LIB	ansi_LF


.ansi_putc
 
  push af
  ld a,(text_cols)
  ld d,a
  ld a,(ansi_COLUMN)
  cp d          ; last column ?
  call nc,ansi_LF; yes
  pop af
  call ansi_CHAR
  ld a,(ansi_COLUMN)
  inc a
  ld (ansi_COLUMN),a
  ret
