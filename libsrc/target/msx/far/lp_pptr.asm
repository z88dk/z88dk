SECTION code_l_sccz80
PUBLIC  lp_pptr

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __msx_virt2log_page
EXTERN  __msx_incptr

; Entry: e'h'l' = logical address
;           hl  = int to write
lp_pptr:
    call    GET_P2
    ex      af,af
    exx
    ld      bc,hl
    call     __msx_virt2log_page
    exx
    ld      a,l
    exx
    ld      (hl),a
    call    __msx_incptr
    exx
    ld      a,h
    exx
    ld      (hl),a
    call    __msx_incptr
    exx
    ld      a,e
    exx
    ld      (hl),a
    ex      af,af
    call    PUT_P2
    ret
