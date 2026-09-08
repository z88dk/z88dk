;
;  feilipu, 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_sqr — packed half square (always +). Existing 11×11 mulu.
;-------------------------------------------------------------------------
; enter: HL = x half
; exit:  HL = x*x  (sign 0)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_f24
EXTERN asm_f16_zero
EXTERN asm_f16_inf
EXTERN asm_f16_nan
EXTERN f16_gbz80_mulu_32_11x11

PUBLIC asm_f16_sqr

.asm_f16_sqr
    ld a,h
    and 07ch
    jp Z,hsqr_zero
    rrca
    rrca
    ld b,a                      ; B = exp
    ld a,h
    and 003h
    or 004h
    ld h,a                      ; HL = mant11
    ld de,hl                    ; DE = HL

    ld a,b
    add a,a                     ; 2*exp
    sub 15
    jp Z,hsqr_zero
    jp C,hsqr_zero
    cp 31
    jp NC,hsqr_ovf

    add a,127-15
    ld b,a
    push bc                     ; [f24exp]

    call f16_gbz80_mulu_32_11x11

    pop bc                      ; B = f24 exp
    ld a,e
    and 020h
    jr NZ,hsqr_ge2

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
    jr Z,hsqr_pack
    ld a,l
    or 001h
    ld l,a
    jr hsqr_pack

.hsqr_ge2
    inc b
    jr Z,hsqr_inf
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
    jr Z,hsqr_pack
    ld a,l
    or 001h
    ld l,a

.hsqr_pack
    xor a
    ld e,a
    ld d,b
    jp asm_f16_f24

.hsqr_ovf
    ld a,b
    cp 31
    jr NZ,hsqr_inf
    ld a,h
    and 003h
    or l
    jp NZ,asm_f16_nan
.hsqr_inf
    xor a
    ld e,a
    jp asm_f16_inf

.hsqr_zero
    xor a
    ld e,a
    jp asm_f16_zero
