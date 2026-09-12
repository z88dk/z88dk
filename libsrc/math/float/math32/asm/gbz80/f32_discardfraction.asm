;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; gbz80 m32_discardfraction
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_discardfraction

; Entry: dehl = 32 bit float
; Exit:  dehl = 32 bit float without fractional part
;        NC = already integer (result equals input)
;        C  = fractional part was discarded
;
; rla forces Z=0. Take the exponent with adc a,a so DEHL stays
; packed until a mask is required. No ex de,hl.

.m32_discardfraction
    ld a,e
    rla
    ld a,d
    adc a,a                     ; A = exp, C = sign, Z iff exp=0
    jp Z,zero_legal

    sub $7f                     ; exponent value of 127 is 1.xx
    jp C,return_zero            ; |x| < 1 -> signed zero, C

    inc a
    cp 24
    jp NC,shift_none            ; |x| >= 2^23: already integer, NC

    push de                     ; original packed
    push hl

    ld hl,0
    ld e,l
    ld d,a                      ; bits to keep

.shift_right
    scf
    ld a,e
    rra
    ld e,a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec d
    jp NZ,shift_right

    pop bc                      ; orig HL
    ld a,c
    and l
    ld l,a
    cp c
    jp NZ,frac_pop_de
    ld a,b
    and h
    ld h,a
    cp b
    jp NZ,frac_pop_de

    pop bc                      ; orig DE
    ld a,c
    and e
    ld e,a
    cp c
    jp NZ,frac_done
    ld d,b                      ; original sign and exponent
    or a                        ; NC: unchanged
    ret

.frac_pop_de
    pop bc                      ; orig DE
    ld a,c
    and e
    ld e,a
.frac_done
    ld d,b
    scf                         ; C: fraction discarded
    ret

.shift_none
    or a                        ; NC, DEHL original
    ret

.return_zero
    ld a,d                      ; sign from original
    rla
    ld de,0
    ld hl,de
    rra
    ld d,a
    scf
    ret

.zero_legal
    ld a,d
    rla
    ld de,0
    ld hl,de
    rra
    ld d,a
    or a                        ; NC: already integer zero
    ret
