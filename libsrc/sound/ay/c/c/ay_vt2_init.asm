
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION	code_psg
    PUBLIC  ay_vt2_init
    PUBLIC  _ay_vt2_init
    PUBLIC  ay_vt2_init_fastcall
    PUBLIC  _ay_vt2_init_fastcall

    EXTERN  asm_VT_INIT

ay_vt2_init:
_ay_vt2_init:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a

ay_vt2_init_fastcall:
_ay_vt2_init_fastcall:
    push    ix
    push    iy
    call    asm_VT_INIT
    pop     iy
    pop     ix
    ret

ENDIF
