IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__

SECTION code_l_sccz80
PUBLIC  lp_gint

EXTERN  __far_init
EXTERN  __far_reset
EXTERN  __far_page
EXTERN  __far_incptr

lp_gint:
    call   __far_init
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      a,(hl)
    call    __far_incptr
    ld      h,(hl)
    ld      l,a
    ex      af,af
    call    __far_reset
    ret

ENDIF
