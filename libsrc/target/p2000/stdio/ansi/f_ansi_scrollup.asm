;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
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

