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

SECTION code_clib
SECTION code_fp_am9511

EXTERN asm_am9511_zero          ; return a legal zero of sign d in dehl

PUBLIC asm_f32_am9511
PUBLIC asm_am9511_f32

.asm_f32_am9511
    ld a,e
    rla                         ; check leading 1 from mantissa
    jp NC,asm_am9511_zero       ; if it was zero, then return ieee zero

    ld a,d                      ; get sign and exponent
    rla                         ; remove sign
    rlca                        ; adjust twos complement exponent
    rra                         ; with sign extention
    rra
    add 127-1                   ; bias including shift binary point

    rl de                       ; get sign to carry, remove 1 leading mantissa
    rra                         ; reposition sign and exponent
    ld d,a                      ; restore exponent and carry
    ld a,e
    rra                         ; resposition exponent and mantissa
    ld e,a

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
    rl de                       ; get sign to carry, shift exponent to d
    push af                     ; save sign in carry

    ld a,d                      ; get exponent
    or a                        ; check for zero
    jp Z,am9511_zero
    cp 127+63                   ; check for overflow
    jp NC,am9511_max
    cp 127-64                   ; check for underflow
    jp C,am9511_zero
    sub 127-1                   ; bias including shift binary point
    rla                         ; position exponent for sign
    ld d,a

    pop af                      ; recover sign

    ld a,d
    rra                         ; position sign and exponent
    ld d,a                      ; restore sign and exponent

    ld a,e
    scf                         ; set mantissa leading 1
    rra                         ; restore 1 & mantissa
    ld e,a
    ret

.am9511_zero
    pop af                      ; recover sign
    ld de,0                     ; no signed zero available
    ld hl,de
    ret

.am9511_max                     ; floating max value of sign d in dehl
    pop af                      ; recover sign
    ld a,07eh                   ; max exponent << 1
    rra                         ; relocate sign and exponent
    ld d,a

    ld e, 0ffh                  ; max exponent and mantissa
    ld h,e
    ld l,e
    ret

