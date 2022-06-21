; sccz80 crt0 library - 8085 version
;
; feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult
PUBLIC l_mult_u
PUBLIC l_mult_0

; HL = DE * HL [signed]
.l_mult
; HL = DE * HL [unsigned]
.l_mult_u
    ld      bc,hl

; HL = DE * BC [signed]
.l_mult_0
    ld      hl,0
    ld      a,4             ; 16 bits (4 iterations)
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
    add     hl,hl
    rl      de
    jp      NC,mul4
    add     hl,bc
.mul4
    add     hl,hl
    rl      de
    jp      NC,mul5
    add     hl,bc
.mul5
    dec     a
    jp      NZ,mul1
    ret
