;
;  feilipu, 2020 May / 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_i16 - gbz80 f24 to int
;-------------------------------------------------------------------------
;
; Native CB srl h / rr l. Count down like math32 f2long. srl/rr write Z
; of the byte — loop on dec b.
;
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
    ld b,a
    ld a,$7e + 16
    sub b
    ld b,a                      ; B = shift count (>= 1)
.iloop
    srl h
    rr l
    dec b
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
