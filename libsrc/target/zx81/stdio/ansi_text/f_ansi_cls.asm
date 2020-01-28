;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000 / Oct 2017
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	filltxt

.ansi_cls

	ld	l,0
	jp	filltxt
