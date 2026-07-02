IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

SECTION code_l_sccz80_far
PUBLIC  lp_gptr

EXTERN  __far_start
EXTERN  __far_end
EXTERN  __far_page
EXTERN  l_far_incptrs

lp_gptr:
    call   __far_start
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ; Stash the low two bytes on the stack rather than in ix: ix is the
    ; frame pointer under -frameix and must survive. l_far_incptrs preserves
    ; af (push/pop), so the pushed bytes outlive each call; the saved bank
    ; lives in af' (read by __far_end), so de/hl are free to rebuild here.
    ld      a,(hl)
    push    af
    call    l_far_incptrs
    ld      a,(hl)
    push    af
    call    l_far_incptrs
    ld      e,(hl)
    ld      d,0
    pop     af
    ld      h,a
    pop     af
    ld      l,a
    ex      af,af
    call    __far_end
    ret
ENDIF
