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
;  asm_f16_int_f24 - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
;  unpacked format: sign in d[7], exponent in e, mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_i8_f24
PUBLIC asm_i16_f24

PUBLIC asm_u8_f24
PUBLIC asm_u16_f24


; convert signed char in l to _f24 in dehl
.asm_i8_f24
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended

; convert integer in hl to _f24 in dehl
.asm_i16_f24
    ld d,h                      ; sign in d[7]
    ld e,142                    ; exponent
    bit 7,h                     ; test sign, negate if negative
    jp Z,asm_f24_normalize      ; straight to normalisation code
    xor a                       ; negate
    sub a,l
    ld l,a
    sbc a,a
    sub a,h
    ld h,a
    jp asm_f24_normalize        ; piggy back on normalisation code

; convert character in l to _f24 in dehl
.asm_u8_f24
    ld h,0

; convert unsigned integer in hl to _f24 in dehl
.asm_u16_f24
    res 7,d                     ; sign in d[7]
    ld e,142                    ; exponent
    jp asm_f24_normalize        ; piggy back on normalisation code

