;
;  feilipu, 2020 May / 2026 August (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul — 8085 half mul (stack-balanced)
;-------------------------------------------------------------------------
; Half×half (asm_f16_mul_callee): packed field extract + 11×11 + pack.
; f24_mul: stack frame for poly/inv/div (left-aligned 16-bit mants).
;
; f24_mul_f24 after CALL: [cret][X.hl][X.de]
; Frame after setup: [cret][Y.hl][Y.de][X.hl][X.de]
;   Y.hl +2 (mant), Y.de +4 (E=sign,D=exp), X.hl +6, X.de +8
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_f24
EXTERN asm_f16_zero
EXTERN asm_f16_inf
EXTERN asm_f16_nan
EXTERN asm_f24_zero
EXTERN asm_f24_inf

PUBLIC asm_f16_mul_callee
PUBLIC asm_f24_mul_callee
PUBLIC asm_f24_mul_f24
PUBLIC f16_8085_mulu_32_16x16
PUBLIC f16_8085_mulu_32_11x11

;-------------------------------------------------------------------------
; Packed half×half mul (8085-native: no exx / ex af,af / srl / bit / set).
; Half: S EEEEE MMMMMMMMMM.  mant11 = (hl & 0x3ff) | 0x400.
; Product p in [2^20, ~2^22) fits in EHL (D=0).
;   p <  2^21: mant = p >> 5
;   p >= 2^21: mant = p >> 6, exp++
; then asm_f16_f24.
;-------------------------------------------------------------------------

; enter: HL=y, stack=[uret][x] → half product in HL
.asm_f16_mul_callee
    pop bc                      ; uret (never pop af for return)
    pop de                      ; x half
    push bc                     ; [uret]

    ld a,d
    xor h
    and 080h
    push af                     ; [sign][uret]  sign in A[7]

    ; ---- y: exp + mant11 ----
    ld a,h
    and 07ch
    jp Z,hmul_uzero
    rrca
    rrca
    ld b,a                      ; B = y.exp
    ld a,h
    and 003h
    or 004h
    ld h,a                      ; HL = y mant11
    push hl                     ; [ym][sign][uret]

    ; ---- x: exp + mant11 ----
    ld a,d
    and 07ch
    jp Z,hmul_xzero_pop
    rrca
    rrca
    ld c,a                      ; C = x.exp
    ld a,d
    and 003h
    or 004h
    ld d,a                      ; D:E = x mant11
    ld hl,de                    ; HL = x mant11
    pop de                      ; DE = y mant11

    ; ---- half exp → f24-biased ----
    ld a,b
    add a,c
    sub 15
    jp Z,hmul_uzero_s           ; under (sign still on stack)
    jp C,hmul_uzero_s
    cp 31
    jp NC,hmul_ovf              ; overflow / Inf / NaN.  Inf × tiny finite
                                ; (sum-15 < 31) stays on the add path — adjunct

    add a,127-15
    ld b,a                      ; B = f24 exp
    push bc                     ; [f24exp][sign][uret]  (C free)

    call f16_8085_mulu_32_11x11 ; DE * HL → DEHL (packed 11×11)

    pop bc                      ; B = f24 exp
    ; D = 0 for 11×11; bit21 of p is E[5]
    ld a,e
    and 020h
    jr NZ,hmul_ge2

    ; Logical EHL >> 5.  No srl e: or a; rra injects 0 into E7.
    ; Unrolled (a counted loop is smaller, slower on TIMER).
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    jr Z,hmul_pack
    ld a,l
    or 001h
    ld l,a
    jr hmul_pack

.hmul_ge2
    inc b
    jr Z,hmul_uinf_pop
    ; Logical EHL >> 6 (same or a; rra chain).
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,e
    or a
    jr Z,hmul_pack
    ld a,l
    or 001h
    ld l,a

.hmul_pack
    pop af                      ; sign
    ld e,a
    ld d,b                      ; f24 exp
    jp asm_f16_f24

.hmul_xzero_pop
    pop hl                      ; drop y mant11; B = y.exp
    ld a,b
    cp 31
    jp Z,hmul_nan_s             ; 0 × Inf/NaN
    jp hmul_uzero_s

.hmul_uzero
    ; y==0; DE=x half; [sign][uret]
    ld a,d
    and 07ch
    cp 07ch
    jp Z,hmul_nan_s
.hmul_uzero_s
    pop af                      ; sign
    ld e,a
    jp asm_f16_zero

.hmul_uinf_s
    pop af
    ld e,a
    jp asm_f16_inf

.hmul_uinf_pop
    pop af                      ; sign (f24 exp already popped)
    ld e,a
    jp asm_f16_inf

    ; Overflow or Inf/NaN.  B=y.exp C=x.exp, DE=y mant11, HL=x mant11.
.hmul_ovf
    ld a,b
    cp 31
    jr Z,hmul_ovf_y
    ld a,c
    cp 31
    jr Z,hmul_ovf_x
    jp hmul_uinf_s

.hmul_ovf_y
    ld a,d
    and 003h
    or e
    jp NZ,hmul_nan_s
    ld a,c
    cp 31
    jp NZ,hmul_uinf_s
.hmul_ovf_x
    ld a,h
    and 003h
    or l
    jp NZ,hmul_nan_s
    jp hmul_uinf_s

.hmul_nan_s
    pop af                      ; drop sign
    jp asm_f16_nan


.asm_f24_mul_callee
.asm_f24_mul_f24
    ; CALL entry: [cret][X.hl][X.de], Y in DEHL
    ; After push, DEHL still holds Y — use it (no reload of Y.de).
    pop bc                      ; cret
    push de
    push hl
    push bc                     ; [cret][Y.hl][Y.de][X.hl][X.de]

    ld bc,de                    ; Y.exp (still in D)
    ld de,sp+8
    ld hl,(de)                  ; L=X.sign H=X.exp
    ld a,l
    xor c
    ld c,a                      ; result sign
    ; ±0 classified by IEEE caller (packed mul / sqr / inv / sqrt / poly)
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
    ; drop [cret][Y][X].  BC=cret and DEHL live → 4× pop af wins over
    ; stack-park + SP adjust (no free pair for the pointer).
    pop bc                      ; cret
    pop af
    pop af
    pop af
    pop af
    push bc
    ret

.mulov2
    ; only E=sign needed; HL free → ld hl,n preserves DE
    ld e,c
    pop bc
    ld hl,8
    add hl,sp
    ld sp,hl
    push bc
    jp asm_f24_inf

.mulov
    ; [cret][Y][X], C=sign
    ld e,c
    pop bc
    ld hl,8
    add hl,sp
    ld sp,hl
    push bc
    jp asm_f24_inf

.mulz
    ld e,c
    pop bc
    ld hl,8
    add hl,sp
    ld sp,hl
    push bc
    jp asm_f24_zero

;--------------------------------------------------------------------
; No operand-zero test (IEEE caller). bit10 / bit15 skip into the chain.
.f16_8085_mulu_32_11x11
    ld a,d
    ld d,0
    ld bc,hl
    add a,a
    add a,a
    add a,a
    add a,a
    add a,a
    add a,a                     ; C = bit10 = 1; chain label is the next bit
    jp hbit9                    ; 11×11 tail parks mid in D (D is 0)

.f16_8085_mulu_32_16x16
    ld a,d
    ld d,0
    ld bc,hl
    add a,a
    jp bit14                    ; f24: bit 15 always 1

; Packed 11×11: after bit7, D is 0 (product < 2^24).  Park the mid
; byte in D instead of BC (B is the multiplicand).  `rr e` is not on
; 8085; C ← E0 then E ← mid, D ← 0.
.hbit9
    add hl,hl
    adc a,a
    jr NC,hbit8
    add hl,bc
    adc a,d
.hbit8
    add hl,hl
    adc a,a
    jr NC,hbit7
    add hl,bc
    adc a,d
.hbit7
    ld d,a
    ld a,e
    and 0feh
    add hl,hl
    adc a,a
    jr NC,hbit6
    add hl,bc
    adc a,0
.hbit6
    add hl,hl
    adc a,a
    jr NC,hbit5
    add hl,bc
    adc a,0
.hbit5
    add hl,hl
    adc a,a
    jr NC,hbit4
    add hl,bc
    adc a,0
.hbit4
    add hl,hl
    adc a,a
    jr NC,hbit3
    add hl,bc
    adc a,0
.hbit3
    add hl,hl
    adc a,a
    jr NC,hbit2
    add hl,bc
    adc a,0
.hbit2
    add hl,hl
    adc a,a
    jr NC,hbit1
    add hl,bc
    adc a,0
.hbit1
    add hl,hl
    adc a,a
    jr NC,hbit0
    add hl,bc
    adc a,0
.hbit0
    add hl,hl
    adc a,a
    jr C,hfunky
    ld d,a                      ; park mid (D was 0)
    ld a,e
    rra                         ; C ← E0
    ld e,d
    ld d,0
    ret NC
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret
.hfunky
    inc d                       ; D was 0 → 1
    ld d,a                      ; park mid
    ld a,e
    rra
    ld e,d
    ld d,1
    ret NC
    add hl,bc
    ret NC
    inc e
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
    push bc                     ; B is multiplicand high; cannot park A there
    ld b,a
    ld a,e
    rra                         ; C ← E0 (last multiplier bit)
    ld a,b
    ld e,a
    pop bc
    ret NC
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret
.funkyCarry
    inc d
    push bc
    ld b,a
    ld a,e
    rra
    ld a,b
    ld e,a
    pop bc
    ret NC
    add hl,bc
    ret NC
    inc e
    ret
