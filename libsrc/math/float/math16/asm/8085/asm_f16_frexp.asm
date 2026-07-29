;
;  feilipu, 2019 May / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_frexp
;-------------------------------------------------------------------------
;  HL = half x; BC = int16_t *pw2
;  Note: asm_f24_f16 uses B as temp — BC must be saved across expand.
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24

PUBLIC asm_f16_frexp

.asm_f16_frexp
    ld a,$7c
    and h
    jr Z,frexp_expand
    cp $7c
    jr NZ,frexp_expand
    xor a
    ld (bc),a
    inc bc
    ld (bc),a
    ret

.frexp_expand
    push bc                     ; save pw2 pointer
    call asm_f24_f16
    pop bc
    ld a,d
    and a
    jr Z,zero
    ld d,$7e
    sub d

.zero
    ld (bc),a
    inc bc
    rla
    sbc a,a
    ld (bc),a
    jp asm_f16_f24
