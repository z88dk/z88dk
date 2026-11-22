;
; 	ANSI Video handling for the ZX81, HR interlaced graphics mode
;	By Stefano Bodrato - Apr. 2025
;
; 	CLS - Clear the screen
;
;
;	$Id: f_ansi_cls_wrxi.asm $
;

    SECTION code_clib
    PUBLIC  ansi_cls
    EXTERN  _clg_hr                     ; we use the graphics CLS routine

    EXTERN  __console_h

ansi_cls:
    call    _clg_hr
    ld      a, 32
    ld      (__console_h), a
    ret
