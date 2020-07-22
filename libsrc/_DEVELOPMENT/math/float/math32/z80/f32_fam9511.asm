;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, July 2020
;
;-------------------------------------------------------------------------
;  f32_fam9511 - z80 format conversion code
;-------------------------------------------------------------------------
;
; convert am9511 float to IEEE-754 float
;
; enter : DEHL = am9511 float
;
; exit  : DEHL = IEEE-754 float
;
; uses  : af, de, hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math32

EXTERN m32_fszero               ; return a legal zero of sign d in dehl

PUBLIC m32_f32_fam9511
PUBLIC m32_fam9511_f32

.m32_f32_fam9511
    sla e                       ; remove leading 1 from mantissa
    jp NC,m32_fszero            ; if it was zero, then return zero

    ld a,d                      ; capture exponent
    rla                         ; adjust twos complement exponent
    sra a                       ; with sign extention
    add 127-1                   ; bias including shift binary point

    rl d                        ; get sign
    rra                         ; position sign and exponent
    rr e                        ; resposition exponent and mantissa
    ld d,a                      ; restore exponent
    ret

;-------------------------------------------------------------------------
;  fam9511_f32 - z80 format conversion code
;-------------------------------------------------------------------------
;
; convert IEEE-754 float to am9511 float
;
; enter : DEHL = IEEE-754 float
;
; exit  : DEHL = am9511 float
;
; uses  : af, de, hl
;
;-------------------------------------------------------------------------

.m32_fam9511_f32
    ld a,d                      ; capture exponent
    sla e
    rl a                        ; position exponent in a
    jr Z,m32_am9511_fszero      ; check for zero
    cp 127+63                   ; check for overflow
    jr NC,m32_am9511_fsmax
    cp 127-64                   ; check for underflow
    jr C,m32_am9511_fszero
    sub 127-1                   ; bias including shift binary point

    rla                         ; position sign
    rl d                        ; get sign
    rra
    ld d,a                      ; restore exponent

    scf                         ; set mantissa leading 1
    rr e                        ; restore mantissa
    ret

.m32_am9511_fszero
    ld de,0                     ; no signed zero available
    ld h,d
    ld l,e
    ret

.m32_am9511_fsmax               ; floating max value of sign d in dehl
    ld a,d
    and 080h                    ; isolate sign
    or 03fh                     ; max exponent
    ld d,a

    ld e, 0ffh                  ; max mantissa
    ld h,e
    ld l,e
    ret

