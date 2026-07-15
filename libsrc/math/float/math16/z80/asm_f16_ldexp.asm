;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_ldexp - z80, z180, z80n load exponent
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f16_zero
EXTERN asm_f16_inf

PUBLIC asm_f16_ldexp

; half_t ldexpf (half_t x, int16_t pw2);
.asm_f16_ldexp
    ; evaluation of fraction and exponent
    ;
    ; enter : stack : ret
    ;            bc : int16_t   pw2
    ;            hl : half_t      x
    ;
    ; exit  :    hl = 16-bit result
    ;            carry reset on success / Inf/NaN passthrough / ±0 input
    ;            carry set on overflow (±Inf) or underflow (±0)
    ;
    ; uses  : af, bc, de, hl

    ld a,$7c                    ; isolate packed exponent
    and h
    jr Z,ldexp_expand           ; zero exp
    cp $7c
    ret Z                       ; Inf/NaN: HL unchanged, NC

.ldexp_expand
    call asm_f24_f16            ; convert to expanded format

    ld a,d                      ; get the exponent
    and a
    jp Z,asm_f16_zero           ; return IEEE signed zero, NC

    add a,c                     ; new_exp = exp + pw2 (f24 bias-127 exp)
    jr C,ldexp_wrap             ; unsigned wrap: over or under

    or a
    jr Z,ldexp_uflow            ; exp 0
    ld d,a
    ; finite half requires f24 exp in [113,142]:
    ;   half_exp 1  -> 1+(127-15) = 113
    ;   half_exp 30 -> 30+112     = 142
    ;   half_exp 31 -> 143        = Inf/NaN class when packed
    cp 127-15+1                 ; 113 = min normal half
    jr C,ldexp_uflow            ; d in 1..112 would pack to zero via f16_f24
    cp 127-15+31                ; 143 = first non-finite half exp
    jr NC,ldexp_oflow

    call asm_f16_f24            ; return IEEE HL half_t
    or a                        ; NC = success
    ret

.ldexp_wrap
    bit 7,c
    jr NZ,ldexp_uflow           ; negative pw2 wrap -> under

.ldexp_oflow
    call asm_f16_inf            ; signed Inf (sign in e)
    scf
    ret

.ldexp_uflow
    call asm_f16_zero           ; signed zero (sign in e)
    scf
    ret
