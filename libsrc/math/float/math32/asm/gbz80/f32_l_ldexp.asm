;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 l_f32_ldexp — apply signed exponent adjustment
;-------------------------------------------------------------------------
;
; Entry: DEHL = float, A = signed exponent adjustment
; Exit:  DEHL = adjusted float
;
; sla e / rl d are native CB ops. rl d writes Z (unlike 8085 rl de).

SECTION code_clib
SECTION code_fp_math32

PUBLIC l_f32_ldexp


.l_f32_ldexp
    sla e                           ; C = exp[0]
    rl d                            ; D = exp, C = sign; Z iff exp==0
    jr Z,zero_legal

    ld b,a                          ; B = delta (A unused by unpack)
    rr e                            ; sign in E[7]

    ld a,d
    add a,b                         ; exp + delta
    ld d,a
    or a
    jr Z,underflow

    sla e                           ; sign → C
    rr d
    rr e
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
    rra                             ; sign into D (must keep CF; rra forces Z=0)
    ld d,a
    ret
