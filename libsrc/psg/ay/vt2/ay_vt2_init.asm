
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION	code_psg
    PUBLIC  ay_vt2_init
    PUBLIC  _ay_vt2_init

    EXTERN  asm_VT_INIT

ay_vt2_init:
_ay_vt2_init:
    push    ix
    push    iy
    call    asm_VT_INIT
    pop     iy
    pop     ix
    ret

ENDIF
