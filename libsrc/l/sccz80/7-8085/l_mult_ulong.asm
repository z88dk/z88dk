; sccz80 crt0 library - 8085 version
;
; feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult_ulong
PUBLIC l_mult_ulong_0

; DEHL = DE * HL [unsigned]
.l_mult_ulong
    ld      bc,hl

; DEHL = DE * BC [unsigned]
.l_mult_ulong_0
    ld      hl,0
    ld      a,8             ; 16 bits (8 iterations)
.mul1
    add     hl,hl
    rl      de
    jp      NC,mul2
    add     hl,bc
    jp      NC,mul2
    inc     de
.mul2
    add     hl,hl
    rl      de
    jp      NC,mul3
    add     hl,bc
    jp      NC,mul3
    inc     de
.mul3
    dec     a
    jp      NZ,mul1
    ret
