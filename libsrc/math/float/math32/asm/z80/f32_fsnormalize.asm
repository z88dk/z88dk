;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize - z80 / z180 / z80n normalisation
;-------------------------------------------------------------------------
;
;  unpacked: h==0; mantissa=lde, sign in b, exponent in c
;
;  ex de,hl → E:HL; byte scan; unrolled residual walk jumps into
;  reverse-label shift tree (add hl,hl / rl de); ex de,hl → pack.
;
;  af' unused for control flow.  Exit: ex af,af; ret (F' → public F).
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize


.m32_fsnormalize
    ld a,b
    push af                     ; save sign

    ex de,hl                    ; E = high, HL = mid:low, D = 0

    ; ---------------------------------------------------------------
    ; Byte scan on E:HL
    ; ---------------------------------------------------------------

    ld a,e
    or a
    jp m,no_shift               ; already normalised
    jr nz,bitwalk

    ld a,h
    or a
    jr nz,need8

    ld a,l
    or a
    jp z,normzero

    ; leading in L → exp −16
    ld e,l
    ld hl,0
    ld a,c
    sub 16
    ld c,a
    jp c,normzero
    jp got_lead

.need8
    ld e,h
    ld h,l
    ld l,0
    ld a,c
    sub 8
    ld c,a
    jp c,normzero

.got_lead
    ld a,e
    or a
    jp m,no_shift
    jp z,normzero

    ; ---------------------------------------------------------------
    ; Unrolled residual walk on A (copy of E); jump into shift tree
    ; B = residual count (set here, only used after shifts)
    ; ---------------------------------------------------------------

.bitwalk
    ld b,1
    add a,a
    jp m,s1
    inc b
    add a,a
    jp m,s2
    inc b
    add a,a
    jp m,s3
    inc b
    add a,a
    jp m,s4
    inc b
    add a,a
    jp m,s5
    inc b
    add a,a
    jp m,s6
    inc b
    add a,a
    jp p,normzero               ; 7th trial still clear → zero
    ; fall through to s7

    ; reverse-label residual shifts (more shifts enter higher)
.s7
    add hl,hl
    rl de
.s6
    add hl,hl
    rl de
.s5
    add hl,hl
    rl de
.s4
    add hl,hl
    rl de
.s3
    add hl,hl
    rl de
.s2
    add hl,hl
    rl de
.s1
    add hl,hl
    rl de

    ld a,c
    sub b
    jp c,normzero
    ld c,a                      ; final exp

.no_shift
    ex de,hl                    ; E:HL → LDE

    pop af                      ; sign
    ld b,a
    ld a,c

    ; pack IEEE DEHL
    rl l
    rl b
    rra
    rr l
    ld h,a
    ex de,hl
    ex af,af
    ret

.normzero
    pop af                      ; drop sign
    ld hl,0
    ld de,hl
    ex af,af
    ret
