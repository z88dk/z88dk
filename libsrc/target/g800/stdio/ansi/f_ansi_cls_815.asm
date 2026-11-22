;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2025
;
; 	CLS - Clear the screen
;
;	$Id: f_ansi_cls_815.asm $
;

    SECTION code_clib
    PUBLIC  ansi_cls

    EXTERN  cleargraphics

ansi_cls:

    jp      cleargraphics
