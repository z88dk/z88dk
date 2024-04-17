SECTION code_l_sccz80
PUBLIC  lp_glong

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __msx_virt2log_page
EXTERN  __msx_incptr

lp_glong:
    call   GET_P2
    ex     af,af
    ld     bc,hl
    call    __msx_virt2log_page
    ; hl = physical address
    ld      a,(hl)
    ld      ixl,a
    call    __msx_incptr
    ld      a,(hl)
    ld      ixh,a
    call    __msx_incptr
    ld      a,(hl)
    call    __msx_incptr
    ld      d,(hl)
    ld      e,a
    push    ix
    pop     hl
    ex      af,af
    call    PUT_P2
    ret