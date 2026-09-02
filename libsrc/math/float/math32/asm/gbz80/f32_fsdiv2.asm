;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 m32_fsdiv2 — divide by 2 (decrement exponent)
;-------------------------------------------------------------------------
;
; rl de expanded through A.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsdiv2_fastcall
PUBLIC _m32_div2f

._m32_div2f
.m32_fsdiv2_fastcall
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a                          ; D = exp, C = sign

    inc d
    dec d
    jp Z,zero_legal

    ld a,d
    inc a
    jr Z,exp_max                    ; Inf/NaN unchanged

    dec d
    jr Z,zero_underflow

    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.exp_max
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.zero_legal
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    ret

.zero_underflow
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    scf
    ret
