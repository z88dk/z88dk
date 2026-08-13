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
;  asm_am9511_popf - am9511 APU pop float
;-------------------------------------------------------------------------
;
;  Load IEEE-754 float from Am9511 APU stack.
;
;  Status register (after BUSY clears): see techdocs/amd/am9511a
;  Am9511 Arithmetic Processor.pdf — BUSY|SIGN|ZERO|ERROR[4:1]|CARRY.
;  ERROR is a 4-bit code (DIV0/NEGRT/UNDFL/OVRFL patterns), not four
;  independent sticky bits.  ZERO must not use the normal bias convert.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_popf


.am9511_popf_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_popf

    ; float primitive
    ; pop a IEEE-754 floating point from the Am9511 stack.
    ;
    ; Convert from am9511_float to IEEE_float.
    ;
    ; enter : stack = ret0
    ;
    ; exit  : dehl = IEEE_float
    ; 
    ; uses  : af, de, hl

    AM9511_IN_APU_STATUS      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jp C,am9511_popf_wait

    AM9511_IN_APU_DATA        ; load MSW from APU
    ld d,a
    AM9511_IN_APU_DATA
    ld e,a

    AM9511_IN_APU_DATA        ; load LSW from APU
    ld h,a
    AM9511_IN_APU_DATA
    ld l,a

    AM9511_IN_APU_STATUS      ; read the APU status register
    and 03eh                    ; errors from status register
    jp NZ,errors

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

    ; A = status & 0x3E.  OVRFL→±Inf, UNDFL→0, NEGRT→NaN, DIV0→±Inf, ZERO→0
.errors
    rrca                        ; OVRFL
    jp C,infinity
    rrca                        ; UNDFL
    jp C,zero
    rrca                        ; NEGRT
    jp C,nan
    rrca                        ; DIV0 → ±Inf (0/0 handled in software specials)
    jp C,infinity
    ; ZERO
.zero
    ld de,0
    ld hl,de
    ret

.nan
    ld a,d
    and 080h
    or 07fh
    ld d,a
    ld e,0ffh
    ld h,e
    ld l,e
    ret

.infinity
    ld a,d
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    ret


