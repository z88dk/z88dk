;
;  feilipu, 2020 May / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_i16 - f24 to int
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_i16_f24
PUBLIC asm_u16_f24

.asm_i16_f24
.asm_u16_f24
    ld a,d
    and a
    jr Z,izero
    cp $7e + 16
    jp NC,imax
.iloop
    or a                        ; clear C for logical shr
    ld b,a                      ; save exp counter
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,b
    inc a
    cp $7e + 16
    jr NZ,iloop
    ld a,e
    rla
    jr NC,idone
    xor a
    sub l
    ld l,a
    sbc a,a
    sub h
    ld h,a
.idone
    ret

.izero
    ld hl,0
    ret

.imax
    ld hl,0FFh
    ret
