;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_fsnormalize - 8085 normalisation code
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
    ld a,l
    rla
    ld l,a
    jr C,S24H1
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24H2
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24H3
    ld a,-3                     ; count
    jr normdone                ; from normalize

.S24H1
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,c                      ; zero adjust
    jr 	normdone0

.S24H2
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,-1
    jr normdone

.S24H3
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,-2
    jr normdone

.S24L                           ; shift 24 bits 4-7 left, count in C
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    ld a,0f0h
    and a,l
    jp Z,S24L4more               ; if still no bits in high nibble, total of 7 shifts
    rl de
    ld a,l
    rla
    ld l,a
; 0, 1 or 2 shifts possible here
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24Lover1
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24Lover2
; 6 shift case
    ld a,-6
    jr normdone

.S24L4more
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    ld a,-7
    jr normdone

.S24Lover1                      ; total of 4 shifts
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,-4
    jr normdone

.S24Lover2                      ; total of 5 shifts
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
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
.normdone0                      ; case of zero shift; A = exponent
    ld h,a                      ; save exponent
    ld a,l
    rla                         ; eject hidden mantissa bit → C
    ld l,a
    ld a,b
    rla                         ; sign → C
    ld a,h                      ; exponent
    rra                         ; sign into A[7], exp[0] → C
    ld h,a
    ld a,l
    rra                         ; exp[0] into L[7]
    ld l,a
    ex de,hl                    ; return DEHL IEEE
    ret

.normzero                       ; return zero
    ld hl,0
    ld de,hl
    ret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; e, l, d=zero
.S8L
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    ld a,0f0h
    and a,e
    jp Z,S8L4more               ; if total is 7
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    jr C,S8Lover1               ; if overshift
    ld a,e
    add a,a
    ld e,a
    jr C,S8Lover2
; total of 6, case 7 already handled
    ld l,e
    ld e,d                      ; zero
    ld a,-22
    jr normdone

.S8Lover1                       ; total of 4
    ld a,e
    rra
    ld e,a
    ld l,e
    ld e,d                      ; zero
    ld a,-20
    jr normdone

.S8Lover2                       ; total of 5
    ld a,e
    rra
    ld e,a
    ld l,e
    ld e,d                      ; zero
    ld a,-21
    jr normdone

.S8L4more
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
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
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h                    ; 8085 rla does not set S — test bit7
    jp NZ,S16L4                 ; complete at 4
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h
    jp NZ,S16L5                 ; complete at 5
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
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    jr C,S16H1                   ; overshift
    and 080h                     ; 8085 rla does not set S
    jp NZ,S16H2                  ; if 1 shift
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h
    jp NZ,S16H3                  ; if 2 ok
; must be 3
    rl de
    ld l,d
    ld d,e
    ld e,0
    ld a,-11
    jp normdone

.S16H1                          ; overshift
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
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
    ld a,e
    add a,a
    ld e,a
    jr C,S8H1                   ; jump if bit found in data
    ld a,e
    add a,a
    ld e,a
    jr C,S8H2
    ld a,e
    add a,a
    ld e,a
    jr C,S8H3
; 3 good shifts, number in a shifted left 3 ok
    ld l,e
    ld e,d                      ; zero
    ld a,-19
    jp normdone

.S8H1
    ld a,e
    rra
    ld e,a
    ld l,e
    ld e,d
    ld a,-16                    ; zero shifts
    jp normdone

.S8H2
    ld a,e
    rra
    ld e,a
    ld l,e
    ld e,d
    ld a,-17                    ; one shift
    jp normdone

.S8H3
    ld a,e
    rra
    ld e,a
    ld l,e
    ld e,d
    ld a,-18
    jp normdone                ; worst case S8H

