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

; Mantissa LDE (L = high); normalized when L bit7 (hidden) set.
.m32_fsnormalize
    ; C1: already normalized (0) or single left shift (1)
    ld a,l
    and 080h
    jp NZ,normdone0_c
    ld a,l
    and 040h
    jp Z,norm_tree
    rl de
    ld a,l
    rla
    ld l,a
    ld a,-1
    jp normdone

.normdone0_c
    ld a,c
    jp normdone0

;-----------------------------------------------------------------------
; C2 tree: nibble dispatch; shared restore/promote tails.
; After C1, S24H only needs 2 or 3 shifts (0/1 handled above).
;-----------------------------------------------------------------------
.norm_tree
    xor a
    or a,l
    jr Z,fa8a
    and 0f0h
    jr Z,S24L
    jr S24H
.fa8a
    or a,d
    jr Z,fa8b
    and 0f0h
    jp Z,S16L
    jp S16H
.fa8b
    or a,e
    jp Z,normzero
    and 0f0h
    jp Z,S8L
    jp S8H

;-----------------------------------------------------------------------
; L high nibble live, bits 7–6 clear → 2 or 3 shifts
.S24H
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
    jr C,S24H_u2                ; 3rd shift overshot → total 2
    ld a,-3
    jr normdone

.S24H_u2
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

;-----------------------------------------------------------------------
; L low nibble only → 4–7 shifts
.S24L
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
    jp Z,S24L4more
    rl de
    ld a,l
    rla
    ld l,a
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24L_u4
    rl de
    ld a,l
    rla
    ld l,a
    jr C,S24L_u5
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

.S24L_u4
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

.S24L_u5
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,-5
    ; fall through

; A = left-shift count (negative); LDE mant; C exp; B sign
.normdone
    add a,c
    jr NC,normzero
.normdone0
    ld h,a
    ld a,l
    rla
    ld l,a
    ld a,b
    rla
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ex de,hl
    ret

.normzero
    ld hl,0
    ld de,hl
    ret

; Promote DE → LDE; A = shift adjust
.prom_de
    ld l,d
    ld d,e
    ld e,0
    jp normdone

; Promote E → L (D is zero); A = shift adjust
.prom_e
    ld l,e
    ld e,d
    jp normdone

;-----------------------------------------------------------------------
; Bits only in E low nibble → 20–23 shifts
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
    jp Z,S8L4more
    ld a,e
    add a,a
    ld e,a
    ld a,e
    add a,a
    ld e,a
    jr C,S8L_u4
    ld a,e
    add a,a
    ld e,a
    jr C,S8L_u5
    ld a,-22
    jr prom_e

.S8L_u4
    ld a,e
    rra
    ld e,a
    ld a,-20
    jr prom_e

.S8L_u5
    ld a,e
    rra
    ld e,a
    ld a,-21
    jr prom_e

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
    ld a,-23
    jr prom_e

;-----------------------------------------------------------------------
; L=0; DE high nibble empty → 12–15 shifts
.S16L
    rl de
    rl de
    rl de
    ld a,0f0h
    and a,d
    jp Z,S16L4more
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h
    jp NZ,S16L4
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h
    jp NZ,S16L5
    rl de
    ld a,-14
    jp prom_de

.S16L4
    ld a,-12
    jp prom_de

.S16L5
    ld a,-13
    jp prom_de

.S16L4more
    rl de
    rl de
    rl de
    rl de
    ld a,-15
    jp prom_de

;-----------------------------------------------------------------------
; L=0; DE high nibble live → 8–11 shifts
.S16H
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    jr C,S16H_u0
    and 080h
    jp NZ,S16H1
    ld a,e
    add a,a
    ld e,a
    ld a,d
    rla
    ld d,a
    and 080h
    jp NZ,S16H2
    rl de
    ld a,-11
    jp prom_de

.S16H_u0
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,-8
    jp prom_de

.S16H1
    ld a,-9
    jp prom_de

.S16H2
    ld a,-10
    jp prom_de

;-----------------------------------------------------------------------
; Bits only in E high nibble → 16–19 shifts
.S8H
    ld a,e
    add a,a
    ld e,a
    jr C,S8H_u0
    ld a,e
    add a,a
    ld e,a
    jr C,S8H1
    ld a,e
    add a,a
    ld e,a
    jr C,S8H2
    ld a,-19
    jr prom_e

.S8H_u0
    ld a,e
    rra
    ld e,a
    ld a,-16
    jr prom_e

.S8H1
    ld a,e
    rra
    ld e,a
    ld a,-17
    jr prom_e

.S8H2
    ld a,e
    rra
    ld e,a
    ld a,-18
    jr prom_e
