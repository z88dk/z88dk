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
;  asm_f24_int2half - z80, z180, z80n unpacked format conversion code
;-------------------------------------------------------------------------
;
;  unpacked format: sign in d[7], exponent in e, mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_f24_half8
PUBLIC asm_f24_half16

PUBLIC asm_f24_half8u
PUBLIC asm_f24_half16u


; convert signed char in l to half in dehl
.asm_f24_half8
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended

; convert integer in hl to half in dehl
.asm_f24_half16
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

; convert character in l to half in hl
.asm_f24_half8u
    ld h,0

; convert unsigned in hl to half in hl
.asm_f24_half16u
    res 7,d                     ; sign in d[7]
    ld e,142                    ; exponent
    jp asm_f24_normalize        ; piggy back on normalisation code

