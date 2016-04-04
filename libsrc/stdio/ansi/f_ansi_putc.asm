;
;       Z80 ANSI Library
;
;---------------------------------------------------
;      Character output
;      x,y coordinates and LineFeed handling
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: f_ansi_putc.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_putc

	EXTERN	ansi_COLUMN

	EXTERN	text_cols

	EXTERN	ansi_CHAR
	EXTERN	ansi_LF


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
