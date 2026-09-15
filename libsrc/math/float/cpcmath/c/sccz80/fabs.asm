;
;	CPC Maths Routines
;

    SECTION code_fp
    PUBLIC  fabs

    EXTERN  fa

fabs:
    ld      hl, fa+4
    res     7, (hl)
    ret

; floatpack init: run the CPC float-state patch at startup via code_crt_init
    SECTION code_crt_init
    EXTERN  init_floatpack
    call    init_floatpack

