;
;  feilipu, 2026 September
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

PUBLIC asm_f16_sqr

; Unrolled 11×11 is plain Z80 only.  z80n/z180/ez80/kc160/rabbit: integer HW mul.
IF __CPU_Z80__
EXTERN mulu_32_16x16_gen
ELSE
EXTERN l_mulu_32_16x16
ENDIF

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
    jp NC,hsqr_ovf              ; overflow or Inf/NaN.  Inf² hits this;
                                ; a hypothetical tiny×Inf path is adjunct-ok

    add a,127-15
    push af                     ; f24 exp in A; pop bc → B=A

IF __CPU_Z80__
    call mulu_32_16x16_gen
ELSE
    call l_mulu_32_16x16
ENDIF

    pop bc                      ; B = f24 exp
    bit 5,e
    jr NZ,hsqr_ge2

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
    jr Z,hsqr_pack
    set 0,l
    jr hsqr_pack

.hsqr_ge2
    inc b
    jp Z,hsqr_inf
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
    jr Z,hsqr_pack
    set 0,l

.hsqr_pack
    xor a
    ld e,a                      ; +
    ld d,b
    jp asm_f16_f24

.hsqr_ovf
    ld a,b
    cp 31
    jr NZ,hsqr_inf              ; finite overflow
    ld a,h
    and 003h
    or l
    jp NZ,asm_f16_nan           ; NaN²
.hsqr_inf
    xor a
    ld e,a
    jp asm_f16_inf

.hsqr_zero
    xor a
    ld e,a
    jp asm_f16_zero
