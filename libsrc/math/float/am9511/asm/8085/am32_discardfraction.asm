;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_discardfraction

; Entry: dehl = 32 bit float
; Exit:  dehl = 32 bit float without fractional part
;        NC = already integer (result equals input)
;        C  = fractional part was discarded

.asm_am9511_discardfraction
    push de                     ; keep sign and exponent safe
    push hl                     ; keep mantissa safe

    rl de                       ; get exponent in d

    ld a,d                      ; exponent
    or a
    jp Z,zero_legal             ; exp 0 -> signed zero, NC

    sub $7f                     ; exponent value of 127 is 1.xx
    jp C,return_zero            ; |x| < 1 -> signed zero, C

    inc a
    cp 24
    jp NC,shift_none            ; |x| >= 2^23: already integer, NC

                                ; build mask of integer bits
                                ; a = number of bits to keep
    ld hl,0
    ld e,l

    ld d,a                      ; use d for loop counter

.shift_right                    ; shift mantissa mask right
    scf                         ; by setting 1s as we go
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
    ld d,b                      ; get original sign and exponent
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
    pop hl                      ; return mantissa
    pop de                      ; return sign and exponent
    or a                        ; NC
    ret

.return_zero
    pop hl                      ; balance stack
    pop de

    ld a,d                      ; get the sign bit
    rla

    ld de,0
    ld hl,de

    rra                         ; return sign and exponent
    ld d,a
    scf                         ; C: discarded fraction
    ret

.zero_legal
    pop hl
    pop de
    ld a,d
    rla
    ld de,0
    ld hl,de
    rra
    ld d,a
    or a                        ; NC: already integer zero
    ret                         ; return IEEE signed ZERO in DEHL
