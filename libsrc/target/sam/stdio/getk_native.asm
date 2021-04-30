;
;       SAM Coupe C Library
;
;	getk_native() Read key status
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001


    SECTION code_driver
    PUBLIC  getk_native
    PUBLIC  _getk_native

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE
    PUBLIC  ___getk_native_protection
    defc ___getk_native_protection = THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE



.getk_native
._getk_native
    call    $0169
    ld      h,0
    jr      nz,gotkey
    ld      l,h
    ret
.gotkey
IF STANDARDESCAPECHARS
    cp      13
    jr      nz,not_return
    ld      a,10
.not_return
ENDIF
    ld      l,a
    ret
