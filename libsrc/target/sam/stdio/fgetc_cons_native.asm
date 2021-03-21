;
;       SAM Coupe C Library
;
;	getkey() Wait for keypress
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001

    SECTION code_driver

    PUBLIC  fgetc_cons_native
    PUBLIC  _fgetc_cons_native

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE
    PUBLIC  ___fgetc_cons_native_protection
    defc ___fgetc_cons_native_protection = THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE



.fgetc_cons_native
._fgetc_cons_native
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
