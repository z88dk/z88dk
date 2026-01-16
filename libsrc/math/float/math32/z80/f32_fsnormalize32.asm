;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize32 - z80, z180, z80n unpacked normalisation code
;-------------------------------------------------------------------------
;
;    unpacked format: mantissa= dehl, exponent in b, sign in c[7]
;    return normalized result also in unpacked format
;
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    xor a
    or a,d
    jr Z,fa8a
    and 0f0h
    jr Z,S32L                   ; shift 32 bits, most significant in low nibble   
    jr S32H                     ; shift 32 bits in high
.fa8a
    or a,e
    jr Z,fa8b
    and 0f0h
    jp Z,S24L                   ; shift 24 bits, most significant in low nibble
    jp S24H                     ; shift 24 bits in high
.fa8b
    or a,h
    jp Z,normzero               ;  all zeros
    and 0f0h
    jp Z,S16L                   ; shift 16 bits, most significant in low nibble 
    jp S16H                     ; shift 16 bits in high

.S32H                           ; shift 32 bits 0 to 3 left
    add hl,hl
    rl de
    jr C,S32H1
    add hl,hl
    rl de
    jr C,S32H2
    add hl,hl
    rl de
    jr C,S32H3
    ld a,-3                     ; count
    jr normdone                 ; from normalize

.S32H1
    rr de                       ; reverse overshift
    rr hl
    ret	                        ; no shift required, return BC DEHL

.S32H2
    rr de
    rr hl
    ld a,-1
    jr normdone

.S32H3
    rr de
    rr hl
    ld a,-2
    jr normdone

.S32L                           ; shift 32 bits 4-7 left
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    ld a,0f0h
    and a,d
    jp Z,S32L4more               ; if still no bits in high nibble, total of 7 shifts
    add hl,hl
    rl de
; 0, 1 or 2 shifts possible here
    add hl,hl
    rl de
    jr C,S32Lover1
    add hl,hl
    rl de
    jr C,S32Lover2
; 6 shift case
    ld a,-6
    jr normdone

.S32L4more
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    add hl,hl
    rl de
    ld a,-7
    jr normdone

.S32Lover1                      ; total of 4 shifts
    rr de
    rr hl                       ; correct overshift
    ld a,-4
    jr normdone

.S32Lover2                      ; total of 5 shifts
    rr de
    rr hl
    ld a,-5                     ; this is the very worst case
                                ; drop through to .normdone

; enter here to continue after normalize
; this path only on subtraction
; a has left shift count, lde has mantissa, b has exponent before shift
; b has original sign of larger number
;
.normdone
    add a,b                     ; exponent of result
    jr NC,normzero              ; if underflow return zero
    ld b,a
    ret                         ; return BC DEHL

.normzero                       ; return zero
    xor a
    ld b,a
    ld d,a
    ld e,a
    ld h,a
    ld l,a
    ret

; all bits in lower 4 bits of h (bits 0-3 of mantissa)
; shift 16 bits 4-7 bits left
.S16L
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,0f0h
    and a,h
    jp Z,S16L4more              ; if total is 7
    add hl,hl                   ; guaranteed
    add hl,hl                   ; 5th shift
    jr C,S16Lover1              ; if overshift
    add hl,hl                   ; the shift
    jr C,S16Lover2
; total of 6, case 7 already handled
    ex de,hl
    ld hl,0                     ; zero
    ld a,-22
    jr normdone

.S16Lover1                      ; total of 4
    rr hl
    ex de,hl
    ld hl,0                     ; zero
    ld a,-20
    jr normdone

.S16Lover2                      ; total of 5
    rr hl
    ex de,hl
    ld hl,0                     ; zero
    ld a,-21
    jr normdone

.S16L4more
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ex de,hl
    ld hl,0                     ; zero
    ld a,-23
    jr normdone

; shift 24 bit fraction by 4-7
; h is zero, 24 bits number in lde
.S24L
    add hl,hl
    rl e
    add hl,hl
    rl e
    add hl,hl
    rl e                        ; 3 shifts
    ld a,0f0h
    and a,e
    jp Z,S24L4more              ; if still not bits n upper after 3
    add hl,hl
    rl e                        ; guaranteed shift 4
    jp M,S24L4                  ; complete at 4
    add hl,hl
    rl e
    jp M,S24L5                  ; complete at 5
    add hl,hl
    rl e                        ; 6 shifts, case of 7 already taken care of must be good
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-14    
    jp normdone

.S24L4
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-12
    jp normdone

.S24L5                          ; for total of 5 shifts left
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-13    
    jp normdone

.S24L4more
    add hl,hl
    rl e
    add hl,hl
    rl e
    add hl,hl
    rl e
    add hl,hl
    rl e
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-15
    jp normdone

; shift 0-3, l is zero
; 16 bits in de
.S24H
    add hl,hl
    rl e
    jr C,S24H1                   ; if zero
    jp M,S24H2                   ; if 1 shift
    add hl,hl
    rl e
    jp M,S24H3                   ; if 2 ok
; must be 3
    add hl,hl
    rl e
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-11
    jp normdone

.S24H1                          ; overshift
    rr e
    rr hl
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-8
    jp normdone

.S24H2                          ; one shift
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-9
    jp normdone

.S24H3
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,-10
    jp normdone

; shift 8 left 0-3
; number in l
.S16H
    add hl,hl
    jr C,S16H1                  ; jump if bit found in data
    add hl,hl
    jr C,S16H2
    add hl,hl
    jr C,S16H3
; 3 good shifts, number in a shifted left 3 ok
    ex de,hl
    ld hl,0                     ; zero
    ld a,-19
    jp normdone

.S16H1
    rr hl                       ; correct overshift
    ex de,hl
    ld hl,0                     ; zero
    ld a,-16                    ; zero shifts
    jp normdone

.S16H2
    rr hl                       ; correct overshift
    ex de,hl
    ld hl,0                     ; zero
    ld a,-17                    ; one shift
    jp normdone

.S16H3
    rr hl                       ; correct overshift
    ex de,hl
    ld hl,0                     ; zero   
    ld a,-18
    jp normdone                ; worst case S16H
