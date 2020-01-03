;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	scrolluptxt


.ansi_SCROLLUP
	jp  scrolluptxt
