;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 sccz80 l_f32_ldexp
; Entry: DEHL = float, A = signed exponent adjustment
; Exit:  DEHL = adjusted float
;

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
    or a
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
    ld e,0
    ld h,0
    ld l,0
    ld d,0
    scf
    ret

.zero_legal
    ; D=0 after unpack; C = sign
    ld e,0
    ld h,0
    ld l,0
    ld a,0
    rra                             ; sign into D
    ld d,a
    ret
