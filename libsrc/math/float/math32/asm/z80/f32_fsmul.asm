;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul - z80 floating point multiply
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
;
; abc * def
;
; = (ab*2^8+c) * (de*2^8+f)
; = ab*de*2^16 +
;   ab*f*2^8 + c*de*2^8 +
;   c*f
;
; = a*d*2^32 + a*e*2^24 + b*d*2^24 + b*e*2^16 + 
;   a*f*2^16 + b*f*2^8 +
;   c*d*2^16 + c*e*2^8 +
;   c*f
;
; = (a*d)*2^32 +
;   (a*e + b*d)*2^24 +
;   (b*e + a*f + c*d)*2^16 +
;   (b*f + c*e)*2^8 +
;   (c*f)*2^0
;
; assume worst overflow case:  abc=def=0xffffff
; assume worst underflow case: abc=def=0x800000
;
;   0xFF FF FF * 0xFF FF FF = 0x FF FF FE 00 00 01
;
;   0x80 00 00 * 0x80 00 00 = 0x 40 00 00 00 00 00
;
;   for underflow, maximum left shift is 1 place
;   so we should report 32 bits of accuracy (don't need all 48 bits)
;   = 24 bits significant + 1 bit shift + 7 bits rounding
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_nzero, m32_fsconst_pzero
EXTERN m32_fsconst_ninf, m32_fsconst_pinf, m32_fsconst_pnan
EXTERN m32_mulu_32h_24x24

PUBLIC m32_fsmul, m32_fsmul_callee


.m32_fsmul
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld hl,002h                  ; get second operand off of the stack
    add hl,sp
    ld e,(hl+)
    ld d,(hl+)
    ld c,(hl+)
    ld h,(hl)
    ld l,c                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    jr fmrejoin


.m32_fsmul_callee
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    pop hl                      ; pop return address
    pop de                      ; get second operand off of the stack
    ex (sp),hl                  ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm; ret → stack

.fmrejoin
    xor a,h                     ; xor sign flags
    ex af,af                    ; AF' = result sign (A'[7])

    add hl,hl                   ; shift exponent into h
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

                                ; After unpack (x on stack, y was DEHL):
                                ;   primary h,lde  = x (left / 2nd unpacked)
                                ;   alt     h',lde' = y (right / 1st unpacked)

    ; ---- specials gate (finite×finite must stay hot) ----
    ; exp 0 / 255 leave here.  Bias-adjust x, then probe y.
    ; INC/DEC do not touch C, so the `sub 07fh` carry survives the y probe
    ; without push/pop af (~13 T saved on the common path).
    ;
    ;   0 × finite → ±0     Inf × 0 → NaN     NaN × * → NaN
    ;   Inf × finite → ±Inf  Inf × Inf → ±Inf
    ;
    ld a,h
    inc a
    jp Z,mul_spec_x             ; x.exp == 255
    dec a
    jp Z,mul_spec_x0            ; x.exp == 0
    sub a,07fh                  ; A = x.exp − bias; C if x.exp < bias
    ld b,a                      ; B = x bias-adjusted
    exx                         ; → y; F.C kept
    ld a,h
    inc a
    jp Z,mul_spec_y             ; y.exp == 255, x finite nonzero
    dec a                       ; A = y.exp; F.C kept
    jr C,mul_exp_uf
    exx                         ; → x; A = y.exp, B = x.adj
    add a,b                     ; sum = y.exp + (x.exp − bias)
    jp C,mul_ovl                ; overflow only if y.exp != 0
    cp b                        ; sum == x.adj ⇒ y.exp == 0
    jp Z,mul_zero
    jr mul_exp_ok

.mul_exp_uf
    exx                         ; → x; A = y.exp, B = x.adj
    add a,b
    jp NC,mul_zero              ; underflow or y.exp == 0

.mul_exp_ok
    exx                         ; → y for 24×24 (primary = y, alt = x)
    ld b,a
    or a
    jp Z,mul_zero               ; sum of exponents is zero

    ex af,af
    ld a,b
    push af                     ; A = exp sum, F = xor sign

                                ; y (1st): h  = exp, lde  = mant
                                ; x (2nd): h' = exp, lde' = mant
    call m32_mulu_32h_24x24     ; HLDE = 32-bit product

    pop bc                      ; B = exp sum, C[7] = sign

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,mul_normed
    sla e
    rl d
    adc hl,hl
    jr mul_round

.mul_normed
    inc b
    jp Z,m32_fsconst_pnan       ; exp was 255 (should not on finite path)
    inc b
    jp Z,mul_ovl                ; product overflow → Inf
    dec b

.mul_round
    ld a,e
    ld e,h                      ; 24-bit mant HLD → EHL
    ld h,l
    ld l,d

    ; IEEE RNE: residual A → G=bit7, S=bits6..0 (via add a,a), B=L.0
    add a,a
    jr NC,mul_pack              ; G=0 → truncate
    jr NZ,mul_round_up          ; G=1 S≠0 → up
    bit 0,l
    jr Z,mul_pack               ; tie, already even
.mul_round_up
    inc l
    jr NZ,mul_pack
    inc h
    jr NZ,mul_pack
    inc e
    jr NZ,mul_pack
    ld hl,0                     ; mant overflow → 1.0, exp++
    ld e,l
    inc b
    jr Z,mul_round_ovl

.mul_pack
    sla e                       ; adjust mantissa for exponent
    sla c                       ; put sign into C
    ld d,b                      ; put exponent in D
    rr de                       ; sign + exp into place
    ret

.mul_round_ovl
    sla c
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf

    ; ---- cold specials ----
    ; After unpack: NaN if L[6:0]|D|E nonzero (implicit 1 sits in L.7).

; x.exp == 255.  Primary = x, alt = y.
.mul_spec_x
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; x NaN
    exx
    ld a,h
    or a
    jp Z,m32_fsconst_pnan       ; 0 × Inf
    inc a
    jr NZ,mul_ovl               ; finite × Inf → ±Inf
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; NaN × Inf
    jr mul_ovl                  ; Inf × Inf → ±Inf

; y.exp == 255, x finite nonzero.  Primary = y.
.mul_spec_y
    ld a,l
    and 07fh
    or d
    or e
    jp NZ,m32_fsconst_pnan      ; y NaN
    jr mul_ovl                  ; Inf × finite → ±Inf

; x.exp == 0.  Primary = x; switch to y to test Inf/NaN.
.mul_spec_x0
    exx
    ld a,h
    inc a
    jp Z,m32_fsconst_pnan       ; Inf/NaN × 0
    ; fall through: finite × 0 or 0 × 0 → signed zero

.mul_zero
    ex af,af
    rla
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero

.mul_ovl
    ex af,af
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf

