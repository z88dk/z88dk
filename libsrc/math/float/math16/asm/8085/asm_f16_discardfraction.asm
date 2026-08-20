;
;  feilipu, 2020 July / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_discardfraction
;  Exit: DEHL = f24 without fractional part
;        NC = already integer; C = fraction discarded
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f24_discardfraction

.asm_f24_discardfraction
    ld a,d
    or a
    jr Z,zero_legal

    sub $7f
    jr C,return_zero

    inc a
    cp 16
    jr C,do_mask
    or a
    ret

.do_mask
    push de                     ; exp/sign
    ld b,a                      ; bits to keep
    push hl                     ; orig mant
    ld hl,0                     ; mask

.mk
    scf
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec b
    jr NZ,mk

    ex de,hl                    ; DE = mask
    pop hl                      ; orig mant
    ld bc,hl                    ; BC = orig
    ld a,d
    and h
    ld h,a
    ld a,e
    and l
    ld l,a                      ; HL = truncated
    pop de                      ; exp/sign

    ld a,l
    cp c
    jr NZ,changed
    ld a,h
    cp b
    jr NZ,changed
    or a
    ret

.changed
    scf
    ret

.return_zero
    ld d,0
    ld h,d
    ld l,d
    scf
    ret

.zero_legal
    ld h,d
    ld l,d
    or a
    ret
