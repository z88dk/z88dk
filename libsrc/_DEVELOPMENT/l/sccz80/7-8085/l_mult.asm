; sccz80 crt0 library - 8085 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult

; HL = DE * HL [signed]
.l_mult
    ld      bc,hl
    dec     de
    ret     Z           ; de = 1 return hl
    ld      hl,0
    jp      K,mul4      ; de = 0 return hl=0
    inc     de
    ld      a,b
    or      c
    ret     Z           ; zero multiplier
    ld      a,8         ; 16 bits (8 iterations)
.mul1
    add     hl,hl
    rl      de
    jp      NC,mul2
    add     hl,bc
.mul2
    add     hl,hl
    rl      de
    jp      NC,mul3
    add     hl,bc
.mul3
    dec     a
    jp      NZ,mul1
.mul4
    ret
