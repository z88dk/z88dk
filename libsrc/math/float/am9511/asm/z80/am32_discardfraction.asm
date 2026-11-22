;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, August 2020
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
    sla e                       ; get the exponent
    rl d
    jr Z,zero_legal             ; exp 0 -> signed zero, NC

    ld a,d                      ; exponent
    rr d                        ; keep sign and exponent safe
    rr e
    sub $7f                     ; exponent value of 127 is 1.xx
    jr C,return_zero            ; |x| < 1 -> signed zero, C

    inc a
    cp 24
    jr C,mask_frac
    or a                        ; |x| >= 2^23: already integer, NC
    ret

.mask_frac
    push de                     ; save original
    push hl

    exx                         ; build mask of integer bits
    ld hl,0                     ; a = number of bits to keep
    ld e,l

.shift_right                    ; shift mantissa mask right
    scf                         ; setting 1s as we go
    rr e
    rr h
    rr l
    dec a
    jr NZ,shift_right

    ld a,e                      ; mask out fractional bits
    exx
    and e
    ld e,a
    ld a,h
    exx
    and h
    exx
    ld h,a
    ld a,l
    exx
    and l
    exx
    ld l,a                      ; dehl = truncated

    pop bc                      ; orig L
    ld a,l
    cp c
    jr NZ,changed_pop
    ld a,h
    cp b
    jr NZ,changed_pop
    pop bc                      ; orig H
    ld a,e
    cp c
    jr NZ,changed
    ld a,d
    cp b
    jr NZ,changed
    or a                        ; identical -> NC
    ret

.changed_pop
    pop bc                      ; drop orig H
.changed
    scf
    ret

.return_zero
    rl d                        ; get the sign bit
    ld d,0
    ld e,d                      ; use 0
    ld h,d
    ld l,d
    rr d                        ; restore the sign
    scf                         ; nonzero |x|<1 -> C
    ret                         ; return IEEE signed ZERO in DEHL

.zero_legal
    ld e,d                      ; use 0
    ld h,d
    ld l,d
    rr d                        ; restore the sign
    or a                        ; NC
    ret                         ; return IEEE signed ZERO in DEHL
