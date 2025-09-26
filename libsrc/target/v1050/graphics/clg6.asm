
    SECTION code_clib

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  fputc_cons
    EXTERN  loadudg6

    EXTERN  generic_console_cls

;
;	$Id: clg6.asm $
;

; ******************************************************************
;
;	Clear graphics area,
;

clg:
_clg:
    call    loadudg6
    ld      l, 12
    jp      generic_console_cls
