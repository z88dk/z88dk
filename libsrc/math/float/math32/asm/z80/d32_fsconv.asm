;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2019 April
;  adapted for z80, z180, and z80n
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_float8
PUBLIC m32_float16
PUBLIC m32_float32

PUBLIC m32_float8u
PUBLIC m32_float16u
PUBLIC m32_float32u

EXTERN m32_fsnormalize

; convert signed char in l to float in dehl
.m32_float8
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended

; convert integer in hl to float in dehl
.m32_float16
    ex de,hl                    ; integer to de
    ld a,d                      ; sign
    rla                         ; get sign to C
    sbc hl,hl                   ; sign extension, all 1's if neg
    ex de,hl                    ; dehl

; now convert long in dehl to float in dehl
.m32_float32
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
    jp PO,dldf0                 ; number in hlde, sign in b[7]

; here negation of 0x80000000 = -2^31 = 0xcf000000
    ld de,0cf00h
    ld hl,0
    ret

; convert character in l to float in dehl
.m32_float8u
    ld h,0

; convert unsigned in hl to float in dehl
.m32_float16u                  
    ld de,0

; convert unsigned long in dehl to float in dehl
.m32_float32u                  
    res 7,b                     ; ensure unsigned long's "sign" bit is reset
                                ; to hold the sign, put copy of MSB into b
                                ; continue, with unsigned long number in dehl
    ex de,hl

.dldf0
; number in hlde, sign in b[7]
    ld c,150                    ; exponent if no shift
    ld a,h
    or a
    jr NZ,dldfright             ; go shift right
; exponent in c, sign in b[7]
    ex af,af                    ; set carry off
    jp m32_fsnormalize          ; piggy back on existing code in _fsnormalize

; must shift right to make h = 0 and mantissa in lde
.dldfright
    ld a,h
    and 0f0h
    jr Z,dldf4                  ; shift right only 1-4 bits

; here shift right 4-8
    srl h
    rr l
    rr de
    srl h
    rr l
    rr de
    srl h
    rr l
    rr de
    srl h
    rr l
    rr de                       ; 4 for sure
    ld c,154                    ; exponent for no more shifts
; here shift right 1-4 more
.dldf4
    ld a,h
    or a
    jr Z,dldf8                  ; done right
    srl h
    rr l
    rr de
    inc c
    ld a,h
    or a
    jr Z,dldf8
    srl h
    rr l
    rr de
    inc c
    ld a,h
    or a
    jr Z,dldf8
    srl h
    rr l
    rr de
    inc c
    ld a,h
    or a
    jr Z,dldf8
    srl h
    rr l
    rr de
    inc c
.dldf8                          ; pack up the floating point mantissa in lde, exponent in c, sign in b[7]
    sla l
    rl b                        ; get sign (if unsigned input, it was forced 0)
    rr c
    rr l
    ld h,c                      ; result in hlde
    ex de,hl 
    ret                         ; result in dehl

