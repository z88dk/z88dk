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

	EXTERN	__console_x

	EXTERN	__console_w

	EXTERN	ansi_CHAR
	EXTERN	ansi_LF


.ansi_putc
 
  push af
  ld a,(__console_w)
  ld d,a
  ld a,(__console_x)
  cp d          ; last column ?
  call nc,ansi_LF; yes
  pop af
  call ansi_CHAR
  ld a,(__console_x)
  inc a
  ld (__console_x),a
  ret
