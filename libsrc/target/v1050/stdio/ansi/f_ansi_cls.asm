;
; 	ANSI Video handling for the Visual 1050
;
; 	CLS - Clear the screen
;
;
;	Stefano Bodrato - 2023
;
;
;	$Id: f_ansi_cls.asm $
;

    SECTION code_clib

    PUBLIC  ansi_cls
    EXTERN  v1050_sendchar
    EXTERN  set_cursor

ansi_cls:
    ld      l, 0x0C
    call    v1050_sendchar
    ld      hl, 0
    jp      set_cursor

