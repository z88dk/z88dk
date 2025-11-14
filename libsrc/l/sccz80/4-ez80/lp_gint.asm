

;
; Entry: EHL=far pointer
; Exit: HL=word

SECTION code_clib
SECTION code_l_sccz80

.ASSUME ADL = 0        ; use the 16 bit address, with MBASE

lp_gint:
    push.l  hl
    ld.lis  hl,2
    add.l   hl,sp
    ld.l    (hl),e
    pop.l   hl
    ld.lis  hl,(hl)
    ret
