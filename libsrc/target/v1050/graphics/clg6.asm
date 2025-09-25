
    SECTION code_clib

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  fputc_cons
    EXTERN  loadudg6


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
    jp      fputc_cons
