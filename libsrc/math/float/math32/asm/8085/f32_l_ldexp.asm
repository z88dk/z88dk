;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; 8085 l_f32_ldexp — apply signed exponent adjustment
;-------------------------------------------------------------------------
;
; Entry: DEHL = float, A = signed exponent adjustment
; Exit:  DEHL = adjusted float
;
; Unpack with rl de (incoming C lands in E[0]). rl de does not write Z —
; test exp with inc d / dec d (sign in C survives). Parking the sign with
; rra shifts that E[0] bit out; no need to or a first.

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_ldexp


.l_f32_ldexp
    rl de                           ; D = exp, C = sign; E[0] = incoming C
    inc d
    dec d                           ; Z iff exp==0; C (sign) kept
    jp Z,zero_legal

    ld b,a                          ; B = delta (A unused by unpack)
    ld a,e
    rra                             ; sign → E[7]; incoming C bit leaves E[0]
    ld e,a

    ld a,d
    add a,b                         ; exp + delta
    ld d,a
    or a
    jp Z,underflow

    ld a,e
    add a,a                         ; sign → C
    ld e,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    or a
    ret

.underflow
    ld de,0
    ld hl,0
    scf
    ret

.zero_legal
    ; D = 0 after unpack; C = sign
    ld hl,0
    ld e,0
    ld a,0
    rra                             ; sign into D (must keep CF; not xor a)
    ld d,a
    ret
