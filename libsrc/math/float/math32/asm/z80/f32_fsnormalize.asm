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
;  ex de,hl → E:HL; D = total left-shift count (byte align + residual).
;  Sign stays in B (no push).  Residual: jp m tree, add hl,hl / rl e.
;  Pack on E:HL like mul/sqr (sla e / rl b / rra / ld d,a / rr e).
;
;  af' unused for control flow.  Exit: ex af,af; ret (F' → public F).
;  Note: jr m/p do not exist; sign/parity branches stay jp.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize


.m32_fsnormalize
    ex de,hl                    ; E = high, HL = mid:low
    ld d,0                      ; shift total

    ; ---------------------------------------------------------------
    ; Byte scan on E:HL
    ; ---------------------------------------------------------------

    ld a,e
    or a
    jp m,no_bit_shift           ; already normalised, D = 0
    jr nz,bitwalk               ; residual only (D = 0)

    ld a,h
    or a
    jr nz,need8

    ld a,l
    or a
    jr z,normzero

    ; leading in L → align 16
    ld e,l
    ld hl,0
    ld d,16
    jr got_lead

.need8
    ld e,h
    ld h,l
    ld l,0
    ld d,8
    ; fall through — E was non-zero H

.got_lead
    ld a,e
    or a
    jp m,no_bit_shift           ; normalised after byte align only
    ; E non-zero; fall into bitwalk (A = E, D = 8 or 16)

    ; ---------------------------------------------------------------
    ; Residual walk on A; D accumulates 1..7; jump into shift tree
    ; ---------------------------------------------------------------

.bitwalk
    inc d
    add a,a
    jp m,s1
    inc d
    add a,a
    jp m,s2
    inc d
    add a,a
    jp m,s3
    inc d
    add a,a
    jp m,s4
    inc d
    add a,a
    jp m,s5
    inc d
    add a,a
    jp m,s6
    inc d
    add a,a
    jp p,normzero               ; 7th trial still clear → zero
    ; fall through to s7 (D = base+7)

.s7
    add hl,hl
    rl e
.s6
    add hl,hl
    rl e
.s5
    add hl,hl
    rl e
.s4
    add hl,hl
    rl e
.s3
    add hl,hl
    rl e
.s2
    add hl,hl
    rl e
.s1
    add hl,hl
    rl e

.no_bit_shift
    ; A = C − D (final exp); B = sign; E:HL = normalised mant
    ld a,c
    sub d
    jr c,normzero

    ; pack IEEE DEHL (mul/sqr style on E high)
    sla e                       ; drop implicit 1 → C
    rl b                        ; sign → C
    rra                         ; A = sign|exp
    ld d,a
    rr e                        ; last exp bit into E; mant bits without implicit 1
    ex af,af
    ret                         ; DEHL

.normzero
    ld hl,0
    ld de,hl
    ex af,af
    ret
