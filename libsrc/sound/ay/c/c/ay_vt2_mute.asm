
IF !__CPU_INTEL__ && !__CPU_GBZ80__

    SECTION code_psg

    PUBLIC  ay_vt2_mute
    PUBLIC  _ay_vt2_mute
    EXTERN  asm_VT_MUTE


ay_vt2_mute:
_ay_vt2_mute:
    push    ix
    call    asm_VT_MUTE
    pop     ix
    ret

ENDIF

