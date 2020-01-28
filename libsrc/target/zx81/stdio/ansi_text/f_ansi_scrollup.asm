;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000/ Oct 2017
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
