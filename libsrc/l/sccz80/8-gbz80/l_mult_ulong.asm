; sccz80 crt0 library - gbz80 version
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
    ld      a,16        ; 16 iterations
.mul1
    add     hl,hl
    rl      e
    rl      d
    jp      NC,mul2
    add     hl,bc
    jp      NC,mul2
    inc     de
.mul2
    dec     a
    jp      NZ,mul1
    ret
