IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

SECTION code_l_sccz80
PUBLIC  lp_glong

EXTERN  __far_init
EXTERN  __far_reset
EXTERN  __far_page
EXTERN  __far_incptr

lp_glong:
    call   __far_init
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      a,(hl)
    ld      ixl,a
    call    __far_incptr
    ld      a,(hl)
    ld      ixh,a
    call    __far_incptr
    ld      a,(hl)
    call    __far_incptr
    ld      d,(hl)
    ld      e,a
    push    ix
    pop     hl
    ex      af,af
    call    __far_reset
    ret

ENDIF
