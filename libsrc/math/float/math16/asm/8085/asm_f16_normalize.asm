;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_normalize - 8085 half floating point unpacked normalisation
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN asm_f24_zero

PUBLIC asm_f24_normalize

.asm_f24_normalize
    xor a
    or a,h
    jr Z,SLSB
    and 0f0h
    jr Z,S8L

.S4L
    add hl,hl
    jr C,S4L1
    add hl,hl
    jr C,S4L2
    add hl,hl
    jr C,S4L3
    ld a,-3
    jp normdone

.S4L1
    ; rr hl reverse overshift
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret

.S4L2
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-1
    jp normdone

.S4L3
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-2
    jp normdone

.S8L
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,0f0h
    and a,h
    jr Z,S8L4more
    add hl,hl
    add hl,hl
    jr C,S8L1
    add hl,hl
    jr C,S8L2
    ld a,-6
    jp normdone

.S8L4more
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,-7
    jp normdone

.S8L1
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-4
    jp normdone

.S8L2
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,-5

.normdone
    add a,d
    jp NC,asm_f24_zero
    ld d,a
    ret

.SLSB
    or a,l
    jp Z,asm_f24_zero
    and 0f0h
    jr Z,S16L

.S12L
    ld a,l
    add a
    jr C,S12L1
    jp M,S12L2
    add a
    jp M,S12L3
    add a
    ld h,a
    ld l,0
    ld a,-11
    jp normdone

.S12L1
    rra
    ld h,a
    ld l,0
    ld a,-8
    jp normdone

.S12L2
    ld h,a
    ld l,0
    ld a,-9
    jp normdone

.S12L3
    ld h,a
    ld l,0
    ld a,-10
    jp normdone

.S16L
    ld a,l
    add a
    add a
    add a
    add a
    add a
    jr C,S16L1
    jp M,S16L2
    add a
    jp M,S16L3
    add a
    ld h,a
    ld l,0
    ld a,-15
    jp normdone

.S16L1
    rra
    ld h,a
    ld l,0
    ld a,-12
    jp normdone

.S16L2
    ld h,a
    ld l,0
    ld a,-13
    jp normdone

.S16L3
    ld h,a
    ld l,0
    ld a,-14
    jp normdone
