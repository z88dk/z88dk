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

.asm_am9511_discardfraction
    push de                     ; keep sign and exponent safe
    push hl                     ; keep mantissa safe

    rl de                       ; get exponent in d

    ld a,d                      ; exponent
    or a
    jp Z,return_zero            ; return IEEE zero

    sub $7f                     ; exponent value of 127 is 1.xx
    jp C,return_zero

    inc a
    cp 24
    jp NC,shift_none            ; no shift needed, all integer

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

    pop bc                      ; return mantissa bits
    ld a,c
    and l
    ld l,a
    ld a,b
    and h
    ld h,a

    pop bc                      ; return exponent and mantissa bits
    ld a,c                      ; first bit of e is exponent
    and e
    ld e,a

    ld d,b                      ; get original sign and exponent
    ret

.shift_none
    pop hl                      ; return mantissa
    pop de                      ; return sign and exponent
    ret

.return_zero
    pop hl                      ; balance stack
    pop de

    ld a,d                      ; get the sign bit
    rla

    ld de,0
    ld hl,de

    ld a,d
    rra                         ; return sign and exponent
    ld d,a

    ret                         ; return IEEE signed ZERO in DEHL

