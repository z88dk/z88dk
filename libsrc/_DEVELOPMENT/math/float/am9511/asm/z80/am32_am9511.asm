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
;  asm_f32_am9511 - z80 format conversion code
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

SECTION code_fp_am9511

EXTERN asm_am9511_zero          ; return a legal zero of sign d in dehl

PUBLIC asm_f32_am9511
PUBLIC asm_am9511_f32

.asm_f32_am9511
    sla e                       ; remove leading 1 from mantissa
    jp NC,asm_am9511_zero       ; if it was zero, then return ieee zero

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
;  asm_am9511_f32 - z80 format conversion code
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

.asm_am9511_f32
    ld a,d                      ; capture exponent
    sla e
    rl a                        ; position exponent in a
    jr Z,am9511_zero            ; check for zero
    cp 127+63                   ; check for overflow
    jr NC,am9511_max
    cp 127-64                   ; check for underflow
    jr C,am9511_zero
    sub 127-1                   ; bias including shift binary point

    rla                         ; position sign
    rl d                        ; get sign
    rra
    ld d,a                      ; restore exponent

    scf                         ; set mantissa leading 1
    rr e                        ; restore mantissa
    ret

.am9511_zero
    ld de,0                     ; no signed zero available
    ld hl,de
    ret

.am9511_max                     ; floating max value of sign d in dehl
    ld a,d
    and 080h                    ; isolate sign
    or 03fh                     ; max exponent
    ld d,a

    ld e, 0ffh                  ; max mantissa
    ld h,e
    ld l,e
    ret

