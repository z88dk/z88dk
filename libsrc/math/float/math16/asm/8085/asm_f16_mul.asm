;
;  feilipu, 2020 May / 2026 July (8085)
;-------------------------------------------------------------------------
;  asm_f16_mul — 8085 half mul (stack-balanced)
;-------------------------------------------------------------------------
; f24_mul_f24 after CALL: [cret][X.hl][X.de]
; Frame after setup: [cret][Y.hl][Y.de][X.hl][X.de]
;   Y.hl +2 (mant), Y.de +4 (E=sign,D=exp), X.hl +6, X.de +8
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf

PUBLIC asm_f16_mul_callee
PUBLIC asm_f24_mul_callee
PUBLIC asm_f24_mul_f24
PUBLIC f16_8085_mulu_32_16x16

.asm_f16_mul_callee
    ; HL=y, stack=[uret][x]
    ; Mul is commutative: leave y on stack as f24_mul's X, x in DEHL as Y.
    call asm_f24_f16            ; y → f24
    push de
    push hl                     ; [y.hl][y.de][uret][x]
    ld de,sp+6
    ld hl,(de)                  ; x half
    call asm_f24_f16            ; x → f24 in DEHL
    call asm_f24_mul_f24        ; drops y; leaves [uret][x]
    pop bc                      ; uret
    pop af                      ; consume x
    push bc
    jp asm_f16_f24

.asm_f24_mul_callee
.asm_f24_mul_f24
    ; CALL entry: [cret][X.hl][X.de], Y in DEHL
    ; After push, DEHL still holds Y — use it (no reload of Y.de).
    pop bc                      ; cret
    push de
    push hl
    push bc                     ; [cret][Y.hl][Y.de][X.hl][X.de]

    ld b,d                      ; Y.exp (still in D)
    ld c,e                      ; Y.sign
    ld de,sp+8
    ld hl,(de)                  ; L=X.sign H=X.exp
    ld a,l
    xor c
    ld c,a                      ; result sign
    ld a,h                      ; X.exp
    or a
    jp Z,mulz
    ld a,b                      ; Y.exp
    or a
    jp Z,mulz

    ld d,b                      ; D = Y.exp
    ld a,h                      ; X.exp
    sub 07fh
    jr C,uf
    add a,d
    jr C,mulov
    jr okexp
.uf
    add a,d
    jp NC,mulz
.okexp
    or a
    jp Z,mulz
    ld b,a                      ; result exp
    push bc                     ; [exp/sign][cret][Y.hl][Y.de][X.hl][X.de]

    ; Y.mant @+4, X.mant @+8 after push
    ld de,sp+8
    ld hl,(de)                  ; X.mant
    ld bc,hl                    ; BC = X.mant
    ld de,sp+4
    ld hl,(de)                  ; HL = Y.mant
    ld de,bc                    ; DE = X.mant
    call f16_8085_mulu_32_16x16

    pop bc                      ; B=exp C=sign

    ld a,d
    rla
    jr C,fm2
    add hl,hl
    rl de
    jr fm3
.fm2
    inc b
    jr Z,mulov2
.fm3
    ex de,hl                    ; HL=high product, DE=low
    ld a,d
    and 0c0h
    jr Z,fm4
    ld a,l
    or 001h
    ld l,a
.fm4
    ld de,bc                    ; DEHL = result
    ; drop [cret][Y.hl][Y.de][X.hl][X.de] (DEHL preserved)
    pop bc                      ; cret
    pop af
    pop af
    pop af
    pop af
    push bc
    ret

.mulov2
    ld e,c
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    jp asm_f24_inf

.mulov
    ; [cret][Y][X], C=sign
    ld e,c
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    jp asm_f24_inf

.mulz
    ld e,c
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    jp asm_f24_zero

;--------------------------------------------------------------------
.f16_8085_mulu_32_16x16
    ld a,d
    ld d,0
    ld bc,hl
    add a,a
    jr C,bit14
    add a,a
    jr C,bit13
    add a,a
    jr C,bit12
    add a,a
    jr C,bit11
    add a,a
    jr C,bit10
    add a,a
    jr C,bit9
    add a,a
    jr C,bit8
    add a,a
    jr C,bit7
    ld a,e
    and 0feh
    add a,a
    jr C,bit6
    add a,a
    jr C,bit5
    add a,a
    jr C,bit4
    add a,a
    jr C,bit3
    add a,a
    jr C,bit2
    add a,a
    jr C,bit1
    add a,a
    jr C,bit0
    ld a,e
    rra
    ret C
    ld hl,de
    ret
.bit14
    add hl,hl
    adc a,a
    jr NC,bit13
    add hl,bc
    adc a,d
.bit13
    add hl,hl
    adc a,a
    jr NC,bit12
    add hl,bc
    adc a,d
.bit12
    add hl,hl
    adc a,a
    jr NC,bit11
    add hl,bc
    adc a,d
.bit11
    add hl,hl
    adc a,a
    jr NC,bit10
    add hl,bc
    adc a,d
.bit10
    add hl,hl
    adc a,a
    jr NC,bit9
    add hl,bc
    adc a,d
.bit9
    add hl,hl
    adc a,a
    jr NC,bit8
    add hl,bc
    adc a,d
.bit8
    add hl,hl
    adc a,a
    jr NC,bit7
    add hl,bc
    adc a,d
.bit7
    ld d,a
    ld a,e
    and 0feh
    add hl,hl
    adc a,a
    jr NC,bit6
    add hl,bc
    adc a,0
.bit6
    add hl,hl
    adc a,a
    jr NC,bit5
    add hl,bc
    adc a,0
.bit5
    add hl,hl
    adc a,a
    jr NC,bit4
    add hl,bc
    adc a,0
.bit4
    add hl,hl
    adc a,a
    jr NC,bit3
    add hl,bc
    adc a,0
.bit3
    add hl,hl
    adc a,a
    jr NC,bit2
    add hl,bc
    adc a,0
.bit2
    add hl,hl
    adc a,a
    jr NC,bit1
    add hl,bc
    adc a,0
.bit1
    add hl,hl
    adc a,a
    jr NC,bit0
    add hl,bc
    adc a,0
.bit0
    add hl,hl
    adc a,a
    jr C,funkyCarry
    ld b,a
    ld a,e
    rra
    ld a,b
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret
.funkyCarry
    inc d
    ld b,a
    ld a,e
    rra
    ld a,b
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret
