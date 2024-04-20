IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__
SECTION code_l_sccz80
PUBLIC  lp_pint

EXTERN  __far_init
EXTERN  __far_reset
EXTERN  __far_page
EXTERN  __far_incptr

; Entry: e'h'l' = logical address
;           hl  = int to write
lp_pint:
    call    __far_init
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
    ex      af,af
    call    __far_reset
    ret
ENDIF
