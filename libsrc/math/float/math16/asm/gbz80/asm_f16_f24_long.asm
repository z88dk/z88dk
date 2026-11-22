;
;  feilipu, 2020 May / 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_i32 - gbz80 f24 to long
;-------------------------------------------------------------------------
;
; Native CB srl d / rr e / rr h / rr l. Count down like math32 f2long.
;
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
    ld c,a
    ld a,$7e + 32
    sub c
    ld c,a                      ; C = shift count (>= 1)
    ld de,hl
    ld hl,0
.lloop
    srl d
    rr e
    rr h
    rr l
    dec c
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
