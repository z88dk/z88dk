

;
; Entry: E'H'L'=far pointer
;        HL=word

SECTION code_clib
SECTION code_l_sccz80

.ASSUME ADL = 0        ; use the 16 bit address, with MBASE

lp_pint:
    push    hl
    exx
    push.l  hl
    ld.lis  hl,2
    add.l   hl,sp
    ld.l    (hl),e
    pop.l   hl
    pop     de
    ld.l    (hl),e
    inc.l   hl
    ld.l    (hl),d
    ret
