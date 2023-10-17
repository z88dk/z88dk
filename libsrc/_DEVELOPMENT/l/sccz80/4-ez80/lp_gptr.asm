

;
; Entry: EHL=far pointer
; Exit: EHL=pointer stored there...

SECTION code_clib
SECTION code_l_sccz80

.ASSUME ADL = 0        ; use the 16 bit address, with MBASE

lp_gptr:
    push.l  hl
    ld.lis  hl,2
    add.l   hl,sp
    ld.l    (hl),e
    pop.l   hl
    ld.lis  hl,(hl)
    inc.l   hl
    inc.l   hl
    ld.l    e,(hl)
    ret
