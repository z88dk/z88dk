;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_ldexp — apply signed exponent adjustment
;-------------------------------------------------------------------------
;
; 8080-compatible (shared: 8080 / 8085 / gbz80)
; Entry: DEHL = float, A = signed exponent adjustment
; Exit:  DEHL = adjusted float

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_ldexp


.l_f32_ldexp
    ld b,a                          ; B = delta
    ld a,e
    add a,a
    ld e,a                          ; sla e
    ld a,d
    rla
    ld d,a                          ; D = exp, C = sign
    inc d
    dec d                           ; Z iff exp==0; keep C (sign)
    jp Z,zero_legal

    ld a,e
    rra
    ld e,a                          ; put sign in E[7]

    ld a,d
    add a,b                         ; exp + delta
    ld d,a
    or a
    jp Z,underflow

    ; pack: sign from E[7]
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
    ; D=0 after unpack; C = sign
    ld hl,0
    ld e,0
    ld a,0
    rra                             ; sign into D (must keep CF; not xor a)
    ld d,a
    ret
