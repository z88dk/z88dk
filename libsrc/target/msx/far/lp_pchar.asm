SECTION code_l_sccz80
PUBLIC  lp_pchar

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __msx_virt2log_page


; Entry: e'h'l' = logical address
;            l  = char to write
lp_pchar:
    call    GET_P2
    ex      af,af
    exx
    ld      bc,hl
    call     __msx_virt2log_page
    exx
    ld      a,l
    exx
    ld      (hl),a
    ex      af,af
    call    PUT_P2
    ret