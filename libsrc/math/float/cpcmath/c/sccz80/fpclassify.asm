

    SECTION code_fp

    PUBLIC  fpclassify

    EXTERN  fa

; Return 0 = normal
;	 1 = zero
;	 2 = nan
;	 3 = infinite

fpclassify:
    ld      a, (fa+5)                   ;exponent
    ld      hl, 1
    and     a
    ret     z
    dec     hl
    ret

; floatpack init: run the CPC float-state patch at startup via code_crt_init
    SECTION code_crt_init
    EXTERN  init_floatpack
    call    init_floatpack

