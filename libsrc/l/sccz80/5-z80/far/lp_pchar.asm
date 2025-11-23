IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

SECTION code_l_sccz80_far
PUBLIC  lp_pchar

EXTERN  __far_start
EXTERN  __far_end
EXTERN  __far_page


; Entry: e'h'l' = logical address
;            l  = char to write
lp_pchar:
    call    __far_start
    ex      af,af
    exx
    ld      bc,hl
    call     __far_page
    exx
    ld      a,l
    exx
    ld      (hl),a
    ex      af,af
    call    __far_end
    ret
ENDIF
