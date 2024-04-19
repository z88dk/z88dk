SECTION code_l_sccz80
PUBLIC  lp_gptr

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __far_page
EXTERN  __far_incptr

lp_gptr:
    call   GET_P2
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
    ld      e,(hl)
    ld      d,0
    push    ix
    pop     hl
    ex      af,af
    call    PUT_P2
    ret