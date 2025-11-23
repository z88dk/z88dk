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
; m32_fsnormalize - z80, z180, z80n normalisation code
;-------------------------------------------------------------------------
;
;    enter here with af' carry clear for m32_float32, m32_float32u
;
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize

; enter here with af' carry clear for float functions m32_float32, m32_float32u
.m32_fsnormalize
    xor a
    or a,l
    jr Z,fa8a
    and 0f0h
    jr Z,S24L                   ; shift 24 bits, most significant in low nibble   
    jr S24H                     ; shift 24 bits in high
.fa8a
    or a,d
    jr Z,fa8b
    and 0f0h
    jp Z,S16L                   ; shift 16 bits, most significant in low nibble
    jp S16H                     ; shift 16 bits in high
.fa8b
    or a,e
    jp Z,normzero               ;  all zeros
    and 0f0h
    jp Z,S8L                    ; shift 8 bits, most significant in low nibble 
    jp S8H                      ; shift 8 bits in high

.S24H                           ; shift 24 bits 0 to 3 left, count in c
    rl de
    rl l
    jr C,S24H1
    rl de
    rl l
    jr C,S24H2
    rl de
    rl l
    jr C,S24H3
    ld a,-3                     ; count
    jr normdone                ; from normalize

.S24H1
    rr l
    rr de                       ; reverse overshift
    ld a,c                      ; zero adjust
    jr 	normdone0

.S24H2
    rr l
    rr de
    ld a,-1
    jr normdone

.S24H3
    rr l
    rr de
    ld a,-2
    jr normdone

.S24L                           ; shift 24 bits 4-7 left, count in C
    rl de
    rl l
    rl de
    rl l
    rl de
    rl l
    ld a,0f0h
    and a,l
    jp Z,S24L4more               ; if still no bits in high nibble, total of 7 shifts
    rl de
    rl l
; 0, 1 or 2 shifts possible here
    rl de
    rl l
    jr C,S24Lover1
    rl de
    rl l
    jr C,S24Lover2
; 6 shift case
    ld a,-6
    jr normdone

.S24L4more
    rl de
    rl l
    rl de
    rl l
    rl de
    rl l
    rl de
    rl l
    ld a,-7
    jr normdone

.S24Lover1                      ; total of 4 shifts
    rr l
    rr de                       ; correct overshift
    ld a,-4
    jr normdone

.S24Lover2                      ; total of 5 shifts
    rr l
    rr de
    ld a,-5                     ; this is the very worst case
                                ; drop through to .normdone

; enter here to continue after normalize
; this path only on subtraction
; a has left shift count, lde has mantissa, c has exponent before shift
; b has original sign of larger number
;
.normdone
    add a,c                     ; exponent of result
    jr NC,normzero              ; if underflow return zero
.normdone0                      ; case of zero shift
    rl l
    rl b                        ; sign
    rra
    rr l
    ld h,a                      ; exponent
    ex de,hl                    ; return DEHL
    ex af,af
    ret

.normzero                       ; return zero
    ld hl,0
    ld d,h
    ld e,l
    ex af,af
    ret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; e, l, d=zero
.S8L
    sla e
    sla e
    sla e
    ld a,0f0h
    and a,e
    jp Z,S8L4more               ; if total is 7
    sla e                       ; guaranteed
    sla e                       ; 5th shift
    jr C,S8Lover1               ; if overshift
    sla e                       ; the shift
    jr C,S8Lover2
; total of 6, case 7 already handled
    ld l,e
    ld e,d                      ; zero
    ld a,-22
    jr normdone

.S8Lover1                       ; total of 4
    rr e
    ld l,e
    ld e,d                      ; zero
    ld a,-20
    jr normdone

.S8Lover2                       ; total of 5
    rr e
    ld l,e
    ld e,d                      ; zero
    ld a,-21
    jr normdone

.S8L4more
    sla e
    sla e
    sla e
    sla e
    ld l,e
    ld e,d                      ; zero
    ld a,-23
    jr normdone

; shift 16 bit fraction by 4-7
; l is zero, 16 bits number in de
.S16L
    rl de
    rl de
    rl de                       ; 3 shifts
    ld a,0f0h
    and a,d
    jp Z,S16L4more              ; if still not bits n upper after 3
    sla e
    rl d                        ; guaranteed shift 4
    jp M,S16L4                  ; complete at 4
    sla e
    rl d
    jp M,S16L5                  ; complete at 5
    rl de                       ; 6 shifts, case of 7 already taken care of must be good
    ld l,d
    ld d,e
    ld e,0
    ld a,-14
    jp normdone

.S16L4
    ld l,d
    ld d,e
    ld e,0
    ld a,-12
    jp normdone

.S16L5                          ; for total of 5 shifts left
    ld l,d
    ld d,e
    ld e,0
    ld a,-13
    jp normdone

.S16L4more
    rl de
    rl de
    rl de
    rl de
    ld l,d
    ld d,e
    ld e,0
    ld a,-15
    jp normdone

; shift 0-3, l is zero
; 16 bits in de
.S16H
    sla e
    rl d
    jr C,S16H1                   ; if zero
    jp M,S16H2                   ; if 1 shift
    sla e
    rl d
    jp M,S16H3                   ; if 2 ok
; must be 3
    rl de
    ld l,d
    ld d,e
    ld e,0
    ld a,-11
    jp normdone

.S16H1                          ; overshift
    rr de
    ld l,d
    ld d,e
    ld e,0
    ld a,-8
    jp normdone

.S16H2                          ; one shift
    ld l,d
    ld d,e
    ld e,0
    ld a,-9
    jp normdone

.S16H3
    ld l,d
    ld d,e
    ld e,0
    ld a,-10
    jp normdone

; shift 8 left 0-3
; number in e, l, d==zero
.S8H
    sla e
    jr C,S8H1                   ; jump if bit found in data
    sla e
    jr C,S8H2
    sla e
    jr C,S8H3
; 3 good shifts, number in a shifted left 3 ok
    ld l,e
    ld e,d                      ; zero
    ld a,-19
    jp normdone

.S8H1
    rr e                        ; correct overshift
    ld l,e
    ld e,d
    ld a,-16                    ; zero shifts
    jp normdone

.S8H2
    rr e                        ; correct overshift
    ld l,e
    ld e,d
    ld a,-17                    ; one shift
    jp normdone

.S8H3
    rr e                        ; correct overshift
    ld l,e
    ld e,d
    ld a,-18
    jp normdone                ; worst case S8H

