;       Small C+ Z80 Run time library
;       The new case statement..maybe things will work now!
;       13/10/98


                SECTION   code_crt0_sccz80
        PUBLIC    l_case



.l_case
        ex de,hl                ;de = switch value
        pop hl                  ;hl -> switch table
.swloop
        ld c,(hl)
        inc hl
        ld b,(hl)               ;bc -> case addr, else 0
        inc hl
        ld a,b
        or c
        jr z,swend              ;default or continuation code
        ld a,(hl)
        inc hl
        cp e
        ld a,(hl)
        inc hl
        jr nz,swloop
        cp d
        jr nz,swloop
        ld h,b                  ;cases matched
        ld l,c
.swend
        jp (hl)


