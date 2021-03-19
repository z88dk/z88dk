;
;       SAM Coupe C Library
;
;	getkey() Wait for keypress
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001

    SECTION code_clib

    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE
    PUBLIC  ___fgetc_cons_protection
    defc ___fgetc_cons_protection = THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE



.fgetc_cons
._fgetc_cons
    xor     a
    call    $0166	;flush keyboard buffer
loop:
    call    $016C
    and     a
    jr      z,loop
IF STANDARDESCAPECHARS
    cp      13
    jr      nz,not_return
    ld      a,10
.not_return
ENDIF
    ld      h,0
    ld      l,a
    ret
