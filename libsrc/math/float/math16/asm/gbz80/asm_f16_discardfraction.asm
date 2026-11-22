;
;  feilipu, 2020 July / 2026 September (gbz80)
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
;
; Mask in BC with native rr b / rr c. Orig mantissa popped to BC after
; the AND. DE (exp/sign) stays put. Do not ex de,hl (56c synthetic).
;
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
    push hl                     ; orig mant
    ld bc,0                     ; mask
.mk
    scf
    rr b
    rr c
    dec a
    jr NZ,mk

    ld a,b
    and h
    ld h,a
    ld a,c
    and l
    ld l,a                      ; HL = truncated
    pop bc                      ; orig mant

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
