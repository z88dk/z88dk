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
;  asm_am9511_pushf - am9511 APU push float
;-------------------------------------------------------------------------
; 
;  Load IEEE-754 float into Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_pushf
PUBLIC asm_am9511_pushf_fastcall


.asm_am9511_pushf

    ; float primitive
    ; push a IEEE-754 floating point into Am9511 stack.
    ;
    ; Convert from IEEE_float to am9511_float.
    ;
    ; enter : stack = IEEE_float, ret1, ret0
    ;
    ; exit  : stack = IEEE_float, ret1
    ; 
    ; uses      : af, bc
    ; preserves : de, hl

;   AM9511_IN_APU_STATUS      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jp C,asm_am9511_pushf

    push de                     ; preserve dehl
    ld bc,hl

    ld de,sp+6

    ld a,(de)                   ; load LSW into APU
    AM9511_OUT_APU_DATA

    inc de
    ld a,(de)
    AM9511_OUT_APU_DATA

    inc de
    ld hl,(de)                  ; get exponent and mantissa MSW

    add hl,hl                   ; shift exponent to h

    ld a,h                      ; get exponent to a
    or a                        ; set exponent flags
    jp Z,asm_am9511_zero        ; check for zero
    cp 127+63                   ; check for overflow
    jp NC,asm_am9511_max
    cp 127-64                   ; check for underflow
    jp C,asm_am9511_zero
    sub 127-1                   ; remove bias including shift binary point
    rla                         ; position 7-bit exponent for sign
    ld h,a

    ld a,l                      ; get mantissa to a
    scf                         ; set mantissa MSB to 1
    rra
    AM9511_OUT_APU_DATA       ; load mantissa MSB into APU

    inc de
    ld a,(de)                   ; get sign
    rla

    ld a,h
    rra
    AM9511_OUT_APU_DATA       ; load exponent into APU

    ld hl,bc
    pop de                      ; recover dehl
    ret

.asm_am9511_max
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    ld a,0ffh                   ; confirm we have maximum
    AM9511_OUT_APU_DATA       ; load mantissa into APU
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA

    inc de
    ld a,(de)                   ; get sign
    rla
    ld a,07eh                   ; max exponent << 1
    rra
    AM9511_OUT_APU_DATA       ; load maximum exponent into APU

    ld hl,bc
    pop de                      ; recover dehl
    ret

.asm_am9511_zero
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    xor a                       ; confirm we have a zero
    AM9511_OUT_APU_DATA       ; load zero mantissa into APU
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA       ; load zero exponent into APU

    ld hl,bc
    pop de                      ; recover dehl
    ret


.asm_am9511_pushf_fastcall

    ; float primitive
    ; push a IEEE-754 floating point into Am9511 stack.
    ;
    ; Convert from IEEE_float to am9511_float.
    ;
    ; enter : stack = ret1, ret0
    ;       :  dehl = IEEE_float
    ;
    ; exit  : stack = ret1
    ; 
    ; uses  : af, de, hl

    rl de                       ; get sign to carry, move exponent to d
    push af                     ; save sign in carry

    ld a,d                      ; get exponent
    or a                        ; check for zero
    jp Z,asm_am9511_zero_fastcall
    cp 127+63                   ; check for overflow
    jp NC,asm_am9511_max_fastcall
    cp 127-64                   ; check for underflow
    jp C,asm_am9511_zero_fastcall
    sub 127-1                   ; bias including shift binary point
    rla                         ; position 7-bit exponent for sign
    ld d,a

    pop af                      ; recover sign

    ld a,d
    rra                         ; position sign and exponent
    ld d,a                      ; restore sign and exponent

    ld a,e
    scf                         ; set mantissa leading 1
    rra                         ; restore 1 & mantissa
    ld e,a

.pushf_fastcall
;   AM9511_IN_APU_STATUS      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jp C,pushf_fastcall

    ld a,l                      ; load LSW into APU
    AM9511_OUT_APU_DATA
    ld a,h
    AM9511_OUT_APU_DATA

    ld a,e                      ; load MSW into APU
    AM9511_OUT_APU_DATA
    ld a,d
    AM9511_OUT_APU_DATA

    ret

.asm_am9511_zero_fastcall
    pop af                      ; recover sign
    ld de,0                     ; no signed zero available
    ld h,d
    ld l,e
    jp pushf_fastcall

.asm_am9511_max_fastcall        ; floating max value of sign d in dehl
    pop af                      ; recover sign
    ld a,07eh                   ; max exponent << 1
    rra                         ; relocate sign and exponent
    ld d,a

    ld e, 0ffh                  ; max mantissa
    ld h,e
    ld l,e
    jp pushf_fastcall

