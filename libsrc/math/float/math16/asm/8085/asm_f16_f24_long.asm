;
;  feilipu, 2020 May / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_i32 - f24 to long
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_i32_f24
PUBLIC asm_u32_f24

.asm_i32_f24
.asm_u32_f24
    ld b,e                      ; sign
    ld a,d
    and a
    jr Z,lzero
    cp $7e + 32
    jp NC,lmax
    ld de,hl
    ld hl,0
    ld c,a                      ; exp counter
.lloop
    or a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    inc c
    ld a,c
    cp $7e + 32
    jr NZ,lloop
    ld a,b
    rla
    jr NC,ldone
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
.ldone
    ret

.lzero
    ld de,0
    ld hl,0
    ret

.lmax
    ld de,0FFh
    ld hl,0FFh
    ret
