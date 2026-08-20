;
;  feilipu, 2020 / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

SECTION code_clib
SECTION code_fp_math16

EXTERN  asm_f24_f16
EXTERN  asm_f24_discardfraction
EXTERN  asm_f24_add_callee
EXTERN  asm_f16_f24

PUBLIC  asm_f16_floor

.asm_f16_floor
    call asm_f24_f16
    call asm_f24_discardfraction
    jp NC,asm_f16_f24
    ld a,e
    rla
    jp NC,asm_f16_f24           ; positive: trunc is floor
    push de
    push hl
    ld de,07f80h
    ld hl,08000h
    call asm_f24_add_callee
    jp asm_f16_f24
