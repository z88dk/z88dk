;
;       Small C Z88 runtime library
;
; Multiply two 16 bit numbers hl=hl*de ((un)signed)

                SECTION   code_crt0_sccz80
                PUBLIC     l_mult

;New version 15/11/98  based on Spectrum ROM routine

.l_mult
        ld      b,16
        ld      a,h
        ld      c,l
        ld      hl,0
.l_mult1
        add     hl,hl
        rl      c
        rla                     ;DLE 27/11/98
        jr      nc,l_mult2
        add     hl,de
.l_mult2
        djnz    l_mult1
        ret








IF ARCHAIC

.l_mult
        ld b,h
        ld c,l
        ld hl,0
.l_mul1   
        ld a,c
        rrca
        jr nc,l_mul2
        add   hl,de
.l_mul2   
        xor   a
        ld a,b
        rra
        ld b,a
        ld a,c
        rra
        ld c,a
        or b
        ret   z
        xor   a
        ld a,e
        rla
        ld e,a
        ld a,d
        rla
        ld d,a
        or e
        ret   z
        jr l_mul1

ENDIF
