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
;  asm_f16_convert - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
;  unpacked format: sign in d[7], exponent in e, mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_fsnormalize

PUBLIC asm_f16_float8
PUBLIC asm_f16_float16
PUBLIC asm_f16_float32

PUBLIC asm_f16_float8u
PUBLIC asm_f16_float16u
PUBLIC asm_f16_float32u

; convert signed char in l to float in dehl
.asm_f16_float8
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended

; convert integer in hl to float in dehl
.asm_f16_float16
    ex de,hl                    ; integer to de
    ld a,d                      ; sign
    rla                         ; get sign to C
    sbc hl,hl                   ; sign extension, all 1's if neg
    ex de,hl                    ; dehl

; now convert long in dehl to float in dehl
.asm_f16_float32
    ex de,hl                    ; hlde
    ld b,h                      ; to hold the sign, put copy of ULSW into b
    bit 7,h                     ; test sign, negate if negative
    jr Z,dldf0
    ld c,l                      ; LLSW into c
    ld hl,0
    or a                        ; clear C
    sbc hl,de                   ; least
    ex de,hl
    ld hl,0
    sbc hl,bc
    jp dldf0                    ; number in hlde, sign in b[7]

; convert character in l to float in dehl
.asm_f16_float8u
    ld h,0

; convert unsigned in hl to float in dehl
.asm_f16_float16u                  
    ld de,0

; convert unsigned long in dehl to float in dehl
.asm_f16_float32u                  
    res 7,d                     ; ensure unsigned long's "sign" bit is reset
    ld b,d                      ; to hold the sign, put copy of MSB into b
                                ; continue, with unsigned long number in dehl
    ex de,hl                    ; number in hlde, sign in b[7]

.dldf0
    ex de,hl                    ; number in dehl, sign in b[7]
    xor a
    or a,d
    ld c,142                    ; exponent if MSB is zero
    jr Z,SMSB                   ; MSB is zero, we have an int24
    ld l,h
    ld h,e
    ld e,d
    ld c,150                    ;  MSB non zero, exponent if no shift

.SMSB
    or a,e
    jr Z,normalize              ; we have an int16, so need to normalise
    and 0f0h
    jr Z,S12R                   ; shift 4 bits, most significant in low nibble
    jr S16R                     ; shift 8 bits, most significant in high nibble

.normalize
    ld e,142                    ; exponent if MSW is zero
    ld d,b                      ; sign to d[7]
    jp asm_f16_normalize        ; piggy back on normalisation code


.S16R                           ; must shift right to make de = 0 and mantissa in hl
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
    rr l
    inc c
    srl e
    rr h
    rr l                        ; 4 for sure
    inc c                       ; exponent for no more shifts
.S12R                           ; here shift right 1-4 more
    ld a,e
    or a
    jr Z,packup                 ; done right
    
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
.packup                         ; pack up the floating point mantissa in hl, exponent in e, sign in d[7]
    ld d,b                      ; sign in d[7], get sign (if unsigned input, it was forced 0)
    ld e,c                      ; get exponent in e

    ret                         ; result in dehl

