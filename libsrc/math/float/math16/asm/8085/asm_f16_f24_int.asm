;
;  feilipu, 2020 May / 2026 September (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_i16 - 8085 f24 to int
;-------------------------------------------------------------------------
;
; Logical >> HL. First step through A (explicit H7 is 1). Remainder uses
; sra hl (H7 is then 0, so == srl). Count down like math32 f2long.
; sra hl does not write Z — loop on dec b.
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
    or a                        ; logical first step
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec b
    jr Z,isign
.iloop
    sra hl                      ; H7 is 0; Z unchanged
    dec b
    jr NZ,iloop
.isign
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
