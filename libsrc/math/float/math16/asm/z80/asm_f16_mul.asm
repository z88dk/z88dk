;
;  feilipu, 2020 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul - z80 half floating point multiply 16-bit mantissa
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; ab * cd
;
; = (a*c)*2^16 +
;   (a*d + b*c)*2^8 +
;   (b*d)*2^0
;
; assume worst overflow case:  ab=cd=0xffff
; assume worst underflow case: ab=cd=0x8000
;
;   0xFFFF * 0xFFFF = 0x FF FE 00 01
;
;   0x8000 * 0x8000 = 0x 40 00 00 00
;
;   for underflow, maximum left shift is 1 place
;   so we should report 32 bits of accuracy
;   = 16 bits significant
;
; calculation for the z80 is done using unrolled shift+add.
; with zero operand and zero bit elimination for fast multiply option.
;
; unpacked format: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f16_zero
EXTERN asm_f16_inf
EXTERN asm_f16_nan
EXTERN asm_f24_zero
EXTERN asm_f24_inf

PUBLIC asm_f16_mul_callee

PUBLIC asm_f24_mul_callee

PUBLIC asm_f24_mul_f24

;-------------------------------------------------------------------------
; Half×half mul (packed): field extract + 11×11 product + pack.
; Keeps f24_mul for poly/inv/div intermediates (left-aligned 16-bit mants).
;
; Half: S EEEEE MMMMMMMMMM.  Finite mant11 = (hl & 0x3ff) | 0x400.
; Product p of two mant11 is in [2^20, ~2^22) and fits in EHL (D=0).
; Build f24-compatible left-aligned 16-bit mant:
;   p <  2^21:  mant = p >> 5
;   p >= 2^21:  mant = p >> 6, exp++
; then pack with asm_f16_f24.
;-------------------------------------------------------------------------

; enter: y in HL, x on stack → half product in HL
.asm_f16_mul_callee
    pop bc                      ; return
    pop de                      ; x half
    push bc                     ; return back

    ld a,d
    xor h
    ex af,af                    ; result sign in A'[7]

    ; ---- y: exp + mant11 ----
    ld a,h
    and 07ch
    jp Z,hmul_uzero
    rrca
    rrca
    cp 31
    jp Z,hmul_y_hi              ; y Inf/NaN
    ld b,a                      ; B = y.exp
    ld a,h
    and 003h
    or 004h
    ld h,a                      ; HL = y mant11
    push hl

    ; ---- x: exp + mant11 ----
    ld a,d
    and 07ch
    jp Z,hmul_xzero_pop         ; jp: far labels (r4k/r2ka encoding can exceed jr)
    rrca
    rrca
    cp 31
    jp Z,hmul_x_hi              ; x Inf/NaN (y finite)
    ld c,a                      ; C = x.exp
    ld a,d
    and 003h
    or 004h
    ld d,a                      ; D:E = x mant11 (E = original half low)
    ld hl,de                    ; HL = x mant11
    pop de                      ; DE = y mant11

    ; ---- result half exp, then f24-biased for pack ----
    ld a,b
    add a,c
    sub 15
    jp Z,hmul_uzero_fin         ; under: both finite, DE/HL are mant11
    jp C,hmul_uzero_fin
    cp 31
    jp NC,hmul_uinf

    add a,127-15
    push af                     ; B gets f24 exp on pop (push af → pop bc: B=A)

    ; ---- 11×11 product (small high byte → early-out mulu) ----
IF __CPU_Z80__
    call mulu_32_16x16_gen
ELSE
    EXTERN l_mulu_32_16x16
    call l_mulu_32_16x16
ENDIF
    ; DEHL = p, D = 0 always for 11×11

    pop bc                      ; B = f24 exp

    bit 5,e                     ; bit21 of p?
    jr NZ,hmul_ge2

    ; mant = p >> 5  (EHL >> 5 → HL)
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    ld a,e
    or a
    jr Z,hmul_pack
    set 0,l
    jr hmul_pack

.hmul_ge2
    inc b
    jp Z,hmul_uinf
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    srl e
    rr h
    rr l
    ld a,e
    or a
    jr Z,hmul_pack
    set 0,l

.hmul_pack
    ex af,af                    ; A = result sign
    ld e,a
    ld d,b                      ; f24 exp
    jp asm_f16_f24

.hmul_xzero_pop
    pop hl                      ; drop y mant11
    ; x==0, y finite nonzero → signed zero
    jr hmul_uzero_fin

.hmul_uzero
    ; y==0; DE = x half: 0 × Inf/NaN → NaN
    ld a,d
    and 07ch
    cp 07ch
    jp Z,hmul_nan

.hmul_uzero_fin
    ex af,af
    ld e,a
    jp asm_f16_zero

.hmul_uinf
    ex af,af
    ld e,a
    jp asm_f16_inf

    ; ---- cold specials (packed half) ----
.hmul_y_hi                      ; y exp 31; HL=y, DE=x original halves
    ld a,h
    and 003h
    or l
    jp NZ,hmul_nan              ; y NaN
    ld a,d
    and 07ch
    jp Z,hmul_nan               ; Inf × 0
    cp 07ch
    jr NZ,hmul_uinf             ; Inf × finite
    ld a,d
    and 003h
    or e
    jp NZ,hmul_nan              ; Inf × NaN
    jr hmul_uinf                ; Inf × Inf

.hmul_x_hi                      ; x exp 31; y finite, y mant11 on stack
    pop hl                      ; drop y mant11
    ld a,d
    and 003h
    or e
    jp NZ,hmul_nan              ; x NaN
    jr hmul_uinf                ; Inf × finite y

.hmul_nan
    jp asm_f16_nan


; enter here for floating asm_f24_mul_callee, x+y, x on stack, y in dehl, result in dehl
.asm_f24_mul_callee
    exx                         ; y     d  = eeeeeeee e = s-------
                                ;       hl = 1mmmmmmm mmmmmmmm
    pop bc                      ; pop return address
    pop hl                      ; x     d = eeeeeeee e = s------- hl = 1mmmmmmm mmmmmmmm
    pop de
    push bc                     ; return address on stack

.asm_f24_mul_f24
    ; Low-tax finite path (master + one-sided zero like math32).
    ; Inf/NaN algebra is not done here; half specials are handled at
    ; pack/expand (exp→half) and packed helpers (mul2/ldexp/…).
    ld a,e                      ; place op1.s in a[7]
    exx                         ; y in main, x in '

    xor a,e                     ; xor sign flags
    ex af,af                    ; save sign in f'

    ld a,d                      ; y.exp
    or a
    jr Z,mulzero                ; y == 0 → signed zero

    sub a,07fh                  ; subtract bias
    jr C,fmchkuf

    exx                         ; main = x

    ld b,a
    ld a,d                      ; x.exp
    or a
    jr Z,mulzero                ; 0 * finite → signed zero
    ld a,b
    add a,d                     ; sum of exponents
    jr C,mulovl
    ; fall through to fmnouf (common finite path)

.fmnouf
    ld b,a
    or a
    jr Z,mulzero                ; check sum of exponents for zero

    ex af,af
    ld a,b
    push af                     ; stack: sum of exponents a, and xor sign of exponents in f

                                ; first  d  = eeeeeeee e  = s------- hl  = 1mmmmmmm mmmmmmmm
                                ; second d' = eeeeeeee e' = s------- hl' = 1mmmmmmm mmmmmmmm
                                ; sum of exponents in a', xor of exponents in sign f'
    push hl
    exx
    pop de
                                ; multiplication of two 16-bit numbers into a 32-bit product

IF __CPU_Z80__

    call mulu_32_16x16
    
ELSE

    EXTERN l_mulu_32_16x16

    call l_mulu_32_16x16        ; exit  : de * hl = dehl  = 32-bit product

ENDIF

    pop bc                      ; retrieve exponent and sign from stack = b,c[7]

    bit 7,d                     ; need to shift result left if msb!=1
    jr NZ,fm2
    add hl,hl
    rl de
    jr fm3

.fm2
    inc b
    jr Z,mulovl

.fm3
    ex de,hl                    ; put 16 bit mantissa in place, de into hl
    ld a,d                      ; capture 8 rounding bits

    and 0c0h                    ; check for 2 lost bits rounding
    jr Z,fm4
    set 0,l

.fm4
    ld de,bc                    ; put exponent in d
    ret                         ; return f24 in DEHL

.fmchkuf
    exx                         ; main = x

    ld b,a
    ld a,d                      ; x.exp
    or a
    jr Z,mulzero
    ld a,b
    add a,d                     ; add the exponents
    jr NC,mulzero
    jr fmnouf

.mulovl
    ex af,af                    ; get sign
    ld e,a
    jp asm_f24_inf              ; done overflow

.mulzero
    ex af,af                    ; get sign
    ld e,a
    jp asm_f24_zero             ; done underflow


IF __CPU_Z80__

; Made by Runer112 / Analysed by Zeda / Tested by jacobly
; https://raw.githubusercontent.com/Zeda/z80float/master/common/mul16.z80
;
; Two entries, one unrolled body:
;   mulu_32_16x16     — f24 path: bit15 set, skip leading-zero scan
;   mulu_32_16x16_gen — packed half: 11-bit mants, full early-out
;
; DE*HL --> DEHL
; uses  : af, bc, de, hl

; Packed-half entry first: early-out jumps forward into shared body
.mulu_32_16x16_gen

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
    and %11111110
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
    rr e
    ret C

    ld hl,de
    ret

; f24 entry: bit15 set → fall into shared chain
.mulu_32_16x16

    ld bc,hl
    ld a,d
    ld d,0
    add a,a                     ; D7 always 1; C set
                                ; fall through to .bit14

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
    and %11111110
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
    rr e
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
    rr e
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret

ENDIF

