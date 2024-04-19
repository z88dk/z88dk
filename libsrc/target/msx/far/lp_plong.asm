SECTION code_l_sccz80
PUBLIC  lp_plong

EXTERN  GET_P2
EXTERN  PUT_P2
EXTERN  __far_page
EXTERN  __far_incptr

; Entry: e'h'l' = logical address
;         dehl  = long to write
lp_plong:
    call    GET_P2
    ex      af,af
    exx
    ld      bc,hl
    call     __far_page
    exx
    ld      a,l
    exx
    ld      (hl),a
    call    __far_incptr
    exx
    ld      a,h
    exx
    ld      (hl),a
    call    __far_incptr
    exx
    ld      a,e
    exx
    ld      (hl),a
    call    __far_incptr
    exx
    ld      a,d
    exx
    ld      (hl),a
    ex      af,af
    call    PUT_P2
    ret
