
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_case


; Entry: hl = value to switch on
;       (sp) = switch table (i.e. the return address)
.l_case
    ld de,hl			; switch value
    pop hl                  ;hl = switch table
.swloop
    ld a,(hl+)
    ld c,a
    ld a,(hl+)              ;bc -> case addr, else 0
    ld b,a
    or c
    jr z,swend              ;default or continuation code
    ld a,(hl+)
    cp e
    ld a,(hl+)
    jr nz,swloop
    cp d
    jr nz,swloop
    ld hl,bc                ; cases matched
.swend
    jp (hl)


