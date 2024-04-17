SECTION code_l_sccz80
PUBLIC  lp_gchar

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __msx_virt2log_page


; Entry ehl = extended address
;        hl = sign extended char
lp_gchar:
    call   GET_P2
    ex     af,af
    ld     bc,hl
    call    __msx_virt2log_page
    ; hl = physical address
    ld      l,(hl)
    ld      h,0
    ex      af,af
    call    PUT_P2
    ret
