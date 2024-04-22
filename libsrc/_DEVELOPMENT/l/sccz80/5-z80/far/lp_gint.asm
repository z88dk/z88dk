IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

SECTION code_l_sccz80_far
PUBLIC  lp_gint

EXTERN  __far_start
EXTERN  __far_end
EXTERN  __far_page
EXTERN  l_far_incptrs

lp_gint:
    call   __far_start
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      a,(hl)
    call    l_far_incptrs
    ld      h,(hl)
    ld      l,a
    ex      af,af
    call    __far_end
    ret

ENDIF
