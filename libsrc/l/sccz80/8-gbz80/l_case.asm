
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_case


; Entry: hl = value to switch on
;       (sp) = switch table (i.e. the return address)
.l_case
    ld d,h			;After de = switch value
    ld e,l
    pop hl                  ;hl = switch table
.swloop
    ld c,(hl)
    inc hl
    ld b,(hl)               ;bc -> case addr, else 0
    inc hl
    ld a,b
    or c
    jr z,swend              ;default or continuation code
    ld a,(hl+)
    cp e
    ld a,(hl+)
    jr nz,swloop
    cp d
    jr nz,swloop
    ld h,b                  ;cases matched
    ld l,c
.swend
    jp (hl)


