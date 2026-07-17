;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 frexpf

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsfrexp_callee
PUBLIC _m32_frexpf

._m32_frexpf
.m32_fsfrexp_callee
    ; stack = float *pw2, float x, ret
    pop af
    pop hl
    pop de
    pop bc                      ; pw2
    push af

    rl de                       ; exp in d, sign in C
    ld a,e
    rra                         ; rr e: sign -> e[7]
    ld e,a

    ld a,d
    ld d,0
    and a
    jr Z,zero
    ld d,$7e
    sub d

.zero
    ld (bc),a
    inc bc
    rlca
    sbc a
    ld (bc),a

    ld a,e
    rla                         ; rl e: sign -> C
    ld e,a
    ld a,d                      ; rr de
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret
