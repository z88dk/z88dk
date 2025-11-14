
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dpush2
EXTERN      fa

;------------------------------------------------------
; Push FA onto stack under ret address and stacked word
;------------------------------------------------------
dpush2:
    pop     de      ;save return address
    pop     bc      ;save next word
    ld      hl,(fa+4)
    push    hl
    ld      hl,(fa+2)
    push    hl
    ld      hl,(fa)
    push    hl
    ex      de,hl
    push    bc      ;restore next word
    jp      (hl)    ;return

