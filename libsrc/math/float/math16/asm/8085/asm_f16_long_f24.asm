;
;  feilipu, May 2020 / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_long_f24 - long to f24
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_f24_i32
PUBLIC asm_f24_u32

.asm_f24_i32
    ld b,d
    ld a,d
    rla
    jr NC,shiftright
    xor a
    sub l
    ld l,a
    ld a,0
    sbc a,h
    ld h,a
    ld a,0
    sbc a,e
    ld e,a
    ld a,0
    sbc a,d
    ld d,a
    jr shiftright

.asm_f24_u32
    ld b,0

.shiftright
    xor a
    or a,d
    ld c,142
    jr Z,SMSB
    ld l,h
    ld h,e
    ld e,d
    ld c,150

.SMSB
    or a,e
    jr Z,normalize
    and 0f0h
    jr Z,S12R
    jr S16R

.normalize
    ld d,142
    ld e,b
    jp asm_f24_normalize

.S16R
    call shr1_ehl
    inc c
    call shr1_ehl
    inc c
    call shr1_ehl
    inc c
    call shr1_ehl
    inc c
    ld a,e
    or a
    jr Z,packup

.S12R
    call shr1_ehl
    inc c
    ld a,e
    or a
    jr Z,packup
    call shr1_ehl
    inc c
    ld a,e
    or a
    jr Z,packup
    call shr1_ehl
    inc c
    ld a,e
    or a
    jr Z,packup
    call shr1_ehl
    inc c
.packup
    ld e,b
    ld d,c
    ret

.shr1_ehl
    or a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ret
