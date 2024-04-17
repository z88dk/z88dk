
SECTION code_l_sccz80
PUBLIC  lp_gint

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __msx_virt2log_page
EXTERN  __msx_incptr

lp_gint:
    call   GET_P2
    ex     af,af
    ld     bc,hl
    call    __msx_virt2log_page
    ; hl = physical address
    ld      a,(hl)
    call    __msx_incptr
    ld      h,(hl)
    ld      l,a
    ex      af,af
    call    PUT_P2
    ret
