;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, May 2020
;
;-------------------------------------------------------------------------
;  asm_f16_long_f24 - z80 half float unpacked format conversion
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_f24_i32
PUBLIC asm_f24_u32

; convert long in dehl to _f24 in dehl
.asm_f24_i32
    ld b,d                      ; to hold the sign, put copy of ULSW into b
    bit 7,d                     ; test sign, negate if negative
    jr Z,shiftright

    ex de,hl                    ; hlde
    ld c,l                      ; LLSW into c
    ld hl,0
    or a                        ; clear C
    sbc hl,de                   ; least
    ex de,hl
    ld hl,0
    sbc hl,bc
    ex de,hl
    jp shiftright               ; number in dehl, sign in b[7]

; convert unsigned long in dehl to _f24 in dehl
.asm_f24_u32                  
    res 7,b                     ; ensure unsigned long "sign" bit is reset in b
                                ; continue, with unsigned long number in dehl

.shiftright
    xor a
    or a,d
    ld c,142                    ; exponent if MSB is zero
    jr Z,SMSB                   ; MSB is zero, we have an int24
    ld l,h
    ld h,e
    ld e,d
    ld c,150                    ; MSB non zero, exponent if initial 8 shifts needed

.SMSB
    or a,e
    jr Z,normalize              ; we have an int16, MSW is zero, so need to normalise
    and 0f0h
    jr Z,S12R                   ; shift 4 bits, most significant in low nibble
    jr S16R                     ; shift 8 bits, most significant in high nibble

.normalize
    ld d,142                    ; exponent if MSW is zero
    ld e,b                      ; sign to e[7]
    jp asm_f24_normalize        ; piggy back on normalisation code


.S16R                           ; must shift right to make de = 0 and mantissa in hl
    srl e
    rr h
    rr l
    inc c                       ; increment exponent following each shift
    srl e
    rr h
    rr l
    inc c
    srl e
    rr h
    rr l
    inc c
    srl e
    rr h
    rr l                        ; 4 for sure
    inc c                       ; exponent for no more shifts
    ld a,e
    or a
    jr Z,packup                 ; done right

.S12R                           ; here shift right 1-4 more
    srl e
    rr h
    rr l
    inc c
    ld a,e
    or a
    jr Z,packup

    srl e
    rr h
    rr l
    inc c
    ld a,e
    or a
    jr Z,packup

    srl e
    rr h
    rr l
    inc c
    ld a,e
    or a
    jr Z,packup

    srl e
    rr h
    rr l
    inc c
.packup                         ; pack up the floating point mantissa in hl, exponent in d, sign in e[7]
    ld e,b                      ; sign in e[7], get sign (if unsigned input, it was forced 0)
    ld d,c                      ; get exponent in d

    ret                         ; result in dehl

