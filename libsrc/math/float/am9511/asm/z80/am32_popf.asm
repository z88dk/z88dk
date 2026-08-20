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

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

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
    ; uses  : af, bc, de, hl

    AM9511_IN_APU_STATUS      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jr C,am9511_popf_wait

    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
    in d,(c)                    ; load MSW from APU
    in e,(c)
    in h,(c)                    ; load LSW from APU
    in l,(c)

    ; Re-read status (A was busy-rotated).  Mask ZERO|DIV0|NEGRT|UNDFL|OVRFL.
    ; ZERO must be trapped: APU zero is not valid for the bias convert path.
    AM9511_IN_APU_STATUS
    and 03eh
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

    ; A = status & 0x3E.  APU range is smaller than IEEE; map codes:
    ;   OVRFL → ±Inf, UNDFL → 0, NEGRT → NaN, DIV0 → ±Inf, ZERO → 0
    ; DIV0 as ±Inf matches IEEE x/0 (0/0 is IEEE-gated before the APU).
.errors
    rrca                        ; OVRFL
    jr C,infinity
    rrca                        ; UNDFL
    jr C,zero
    rrca                        ; NEGRT
    jr C,nan
    rrca                        ; DIV0
    jr C,infinity
    ; ZERO
.zero
    ld de,0
    ld h,d
    ld l,e
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

