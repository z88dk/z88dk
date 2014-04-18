;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2014-04-18 07:38:59 stefano Exp $
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	a,4
	call $60C0
	
	ld	a,23
	call $60C0

	ld	a,0
	call $60C0

	ld	a,10
	call $60C0

	ret

