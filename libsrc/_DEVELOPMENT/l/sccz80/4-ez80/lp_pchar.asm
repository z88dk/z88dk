

;
; Entry: E'H'L'=far pointer
;        L=byte

SECTION code_clib
SECTION code_l_sccz80

.ASSUME ADL = 0        ; use the 16 bit address, with MBASE

lp_pchar:
    push    hl
    exx
    push.l  hl
    ld.lis  hl,2
    add.l   hl,sp
    ld.l    (hl),e
    pop.l   hl
    pop     de
    ld.l    (hl),e
    ret
