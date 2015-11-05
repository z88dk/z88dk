;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2015-11-05 16:08:04 stefano Exp $
;


	PUBLIC	ansi_SCROLLUP
	EXTERN	ansi_del_line

.ansi_SCROLLUP

  	ld	hl,8*32
  	ld  de,$e000
	add	hl,de
	ld	bc,32*8*7
	ldir
	
	ld	a,7
	jp	ansi_del_line
