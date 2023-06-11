
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_mult
PUBLIC  l_mult_u
PUBLIC  l_mult_0

; Multiply two 16 bit numbers hl=bc*de ((un)signed)
.l_mult_0
        ld      hl,bc
; Multiply two 16 bit numbers hl=hl*de (signed)
.l_mult
; Multiply two 16 bit numbers hl=hl*de (unsigned)
.l_mult_u
        ld      a,h
        ld      c,l
        ld      b,16
        ld      hl,0

.l_mult1
        add     hl,hl
        rl      c
        rla                     ;DLE 27/11/98
        jr      NC,l_mult2
        add     hl,de
.l_mult2
        djnz    l_mult1
        ret
