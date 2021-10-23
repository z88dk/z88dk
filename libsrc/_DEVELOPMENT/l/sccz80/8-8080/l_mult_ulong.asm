; sccz80 crt0 library - 8080 version
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
    ld      a,16         ; 16 iterations
.mul1
    push    af
    add     hl,hl
    ld      a,e
    rla
    ld      e,a
    ld      a,d
    rla
    ld      d,a
    jp      NC,mul2
    add     hl,bc
    jp      NC,mul2
    inc     de
.mul2
    pop     af
    dec     a
    jp      NZ,mul1
    ret
