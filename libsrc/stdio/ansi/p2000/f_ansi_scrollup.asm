;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_SCROLLUP


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

