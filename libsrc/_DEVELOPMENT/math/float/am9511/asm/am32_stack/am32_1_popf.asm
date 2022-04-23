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
;  asm_am9511_1_popf - am9511 APU pop float
;-------------------------------------------------------------------------
; 
;  Load IEEE-754 float from Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

PUBLIC asm_am9511_1_popf

.am9511_1_popf_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_1_popf

    ; float primitive
    ; pop a IEEE-754 floating point from the Am9511 stack.
    ;
    ; Convert from am9511_float to IEEE_float.
    ;
    ; enter : stack = ret0
    ;
    ; exit  : dehl = IEEE_float
    ; 
    ; uses  : af, bc, de, hl

    in a,(__IO_APU1_STATUS)     ; read the APU status register
    rlca                        ; busy? and __IO_APU1_STATUS_BUSY
    jr C,am9511_1_popf_wait

    ld bc,__IO_APU1_DATA        ; the address of the APU data port in bc
    in d,(c)                    ; load MSW from APU
    in e,(c)
    in h,(c)                    ; load LSW from APU
    in l,(c)

    and 07ch                    ; errors from status register
    jr NZ,errors

    sla e                       ; remove leading 1 from mantissa

    ld a,d                      ; capture exponent
    rla                         ; adjust twos complement exponent
    sra a                       ; with sign extention
    add 127-1                   ; bias including shift binary point

    rl d                        ; get sign
    rra                         ; position sign and exponent
    rr e                        ; resposition exponent and mantissa
    ld d,a                      ; restore exponent
    ret

.errors
    rrca                        ; relocate status bits (just for convenience)
    bit 5,a                     ; zero
    jr NZ,zero
    bit 1,a
    jr NZ,infinity              ; overflow
    bit 2,a
    jr NZ,zero                  ; underflow

.nan
    rl d                        ; get sign
    ld de,0feffh
    rr d                        ; nan exponent
    ld h,e                      ; nan mantissa
    ld l,e
    ret

.infinity
    rl d                        ; get sign
    ld de,0fe80h
    rr d                        ; nan exponent
    ld hl,0                     ; nan mantissa
    ret

.zero
    ld de,0
    ld h,d
    ld l,e
    ret

