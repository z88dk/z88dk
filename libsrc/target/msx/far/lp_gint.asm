
SECTION code_l_sccz80
PUBLIC  lp_gint

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __far_page
EXTERN  __far_incptr

lp_gint:
    call   GET_P2
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      a,(hl)
    call    __far_incptr
    ld      h,(hl)
    ld      l,a
    ex      af,af
    call    PUT_P2
    ret
