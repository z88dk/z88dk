;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_normalize - z80 half floating point unpacked normalisation
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_math

EXTERN asm_f24_zero

PUBLIC asm_f24_normalize

.asm_f24_normalize
    xor a
    or a,h
    jr Z,SLSB
    and 0f0h
    jr Z,S8L                    ; shift <8 bits, most significant in low nibble   
;   jr S4L                      ; shift <4 bits, most significant in high nibble

.S4L                            ; shift 0 to 3 bits left
    add hl,hl
    jr C,S4L1
    add hl,hl
    jr C,S4L2
    add hl,hl
    jr C,S4L3
    ld a,-3                     ; count
    jp normdone                 ; from normalize

.S4L1
    rr h                        ; reverse overshift
    rr l
    ret	                        ; no shift required, return DEHL immediately

.S4L2
    rr h
    rr l
    ld a,-1
    jp normdone

.S4L3
    rr h
    rr l
    ld a,-2
    jp normdone

.S8L                           ; shift 4 to 7 bits left
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,0f0h
    and a,h
    jr Z,S8L4more               ; if still no bits in high nibble, total of 7 shifts
    add hl,hl
    add hl,hl                   ; 0, 1 or 2 shifts possible here
    jr C,S8L1
    add hl,hl
    jr C,S8L2
    ld a,-6                     ; 6 shift case
    jp normdone

.S8L4more
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,-7
    jp normdone

.S8L1                           ; total of 4 shifts
    rr h
    rr l                        ; correct overshift
    ld a,-4
    jp normdone

.S8L2                           ; total of 5 shifts
    rr h
    rr l
    ld a,-5                     ; this is the very worst case
;   jp normdone                 ; drop through to .normdone
                                
; enter here to continue after normalize
; a has left shift count, hl has mantissa, d has exponent before shift
; e[7] has original sign of larger number
;
.normdone
    add a,d                     ; exponent of result
    jp NC,asm_f24_zero          ; if underflow return zero
    ld d,a
    ret                         ; return DEHL


.SLSB
    or a,l
    jp Z,asm_f24_zero           ; mantissa is all zeros, return zero
    and 0f0h
    jr Z,S16L                   ; shift <16 bits, most significant in low nibble
;   jr S12L                     ; shift <12 bits, most significant in high nibble

.S12L                           ; shift 8 to 11 bits left
    ld a,l
    add a
    jr C,S12L1                  ; if zero
    jp M,S12L2                  ; if 1 shift
    add a
    jp M,S12L3                  ; if 2 ok
    add a                       ; must be 3 shifts
    ld h,a
    ld l,0
    ld a,-11
    jp normdone

.S12L1                          ; overshift
    rra
    ld h,a
    ld l,0
    ld a,-8
    jp normdone

.S12L2                          ; one shift
    ld h,a
    ld l,0
    ld a,-9
    jp normdone

.S12L3
    ld h,a
    ld l,0
    ld a,-10
    jp normdone

.S16L                           ; shift 12 to 15 bits left
    ld a,l
    add a
    add a
    add a
    add a
    add a                       ; 5 shifts
    jr C,S16L1                  ; if overshifted, 4 shifts
    jp M,S16L2                  ; if 5 shift
    add a
    jp M,S16L3                  ; complete at 6
    add a                       ; 7 shifts
    ld h,a
    ld l,0
    ld a,-15    
    jp normdone

.S16L1                          ; overshift
    rra
    ld h,a
    ld l,0
    ld a,-12
    jp normdone

.S16L2                          ; 5 shifts
    ld h,a
    ld l,0
    ld a,-13
    jp normdone

.S16L3                          ; 6 shifts
    ld h,a
    ld l,0
    ld a,-14
    jp normdone

