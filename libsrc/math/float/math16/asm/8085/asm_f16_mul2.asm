;
;  feilipu, 2020 June / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul2 - 8085 floating point multiply by 2
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_mul2

.asm_f16_mul2
    ld a,$7c
    and h
    jr Z,zero_legal

    cp $7c
    ret Z

    ld a,h
    add 00000100b
    ld h,a
    cpl
    and $7c
    jr Z,infinity
    ret

.zero_legal
    ld a,h
    add a,a                     ; sign in C
    ld h,0
    ld l,0
    ld a,h
    rra                         ; restore sign
    ld h,a
    ret

.infinity
    ld a,h
    add a,a                     ; sign in C
    ld hl,$f800
    ld a,h
    rra
    ld h,a
    scf
    ret
