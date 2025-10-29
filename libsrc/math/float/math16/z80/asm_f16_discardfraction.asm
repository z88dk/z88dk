;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2020 July
;
;-------------------------------------------------------------------------
;  asm_f24_discardfraction - z80 half floating to half floating integer
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;  return floating int in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_discardfraction

.asm_f24_discardfraction
    ld a,d                      ; Exponent
    or a
    jr Z,zero_legal             ; return f24 signed zero

    sub $7f                     ; Exponent value of 127 is 1.xx
    jr C,return_zero

    inc a
    cp 16
    ret NC                      ; No shift needed, all integer

                                ; a = number of bits to keep
    ld bc,0                     ; build mask for integer bits

.shift_right                    ; shift mantissa mask right
    scf
    rr b
    rr c
    dec a
    jr NZ,shift_right

    ld  a,b                     ; mask out fractional bits
    and h
    ld h,a

    ld a,c
    and l
    ld l,a
    ret


.return_zero
    ld d,0

.zero_legal
    ld h,d                      ; use 0
    ld l,d
    ret                         ; return f24 signed ZERO in DEHL

