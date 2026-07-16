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
;  Exit: dehl = f24 without fractional part
;        NC = already integer (result equals input)
;        C  = fractional part was discarded
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_discardfraction

.asm_f24_discardfraction
    ld a,d                      ; Exponent
    or a
    jr Z,zero_legal             ; exp 0 -> signed zero, NC

    sub $7f                     ; Exponent value of 127 is 1.xx
    jr C,return_zero            ; |x| < 1 -> signed zero, C

    inc a
    cp 16
    jr C,mask_frac
    or a                        ; |x| >= 2^15: already integer, NC
    ret

.mask_frac
    push hl                     ; save original mantissa

                                ; a = number of bits to keep
    ld bc,0                     ; build mask for integer bits

.shift_right                    ; shift mantissa mask right
    scf
    rr b
    rr c
    dec a
    jr NZ,shift_right

    ld a,b                      ; mask out fractional bits
    and h
    ld h,a

    ld a,c
    and l
    ld l,a                      ; hl = truncated mantissa

    pop bc                      ; orig HL
    ld a,l
    cp c
    jr NZ,changed
    ld a,h
    cp b
    jr NZ,changed
    or a                        ; identical -> NC
    ret

.changed
    scf                         ; C: fraction discarded
    ret

.return_zero
    ld d,0
    ld h,d                      ; use 0
    ld l,d
    scf                         ; nonzero |x|<1 -> C
    ret                         ; return f24 signed ZERO in DEHL

.zero_legal
    ld h,d                      ; use 0
    ld l,d
    or a                        ; NC
    ret                         ; return f24 signed ZERO in DEHL
