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
;  asm_am9511_pushf - am9511 APU push float
;-------------------------------------------------------------------------
; 
;  Load IEEE-754 float into Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

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
    ; uses      : af, bc', hl'
    ; preserves : de, hl

;   AM9511_IN_APU_STATUS      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jr C,asm_am9511_pushf

    exx                         ; preserve dehl

    ld hl,4
    add hl,sp

IFNDEF __AM9511_HELPER_FUNC
    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
ENDIF
    AM9511_OUTI                 ; load LSW into APU
    AM9511_OUTI

    ld a,(hl)                   ; get mantissa MSB
    rla                         ; get exponent least significant bit to carry
    inc hl
    ld a,(hl)                   ; get exponent to a
    rl a                        ; get all exponent to a, set flags
    jr Z,asm_am9511_zero        ; check for zero
    cp 127+63                   ; check for overflow
    jr NC,asm_am9511_max
    cp 127-64                   ; check for underflow
    jr C,asm_am9511_zero
    sub 127-1                   ; remove bias including shift binary point

    dec hl
    set 7,(hl)                  ; set mantissa MSB
    AM9511_OUTI                 ; load mantissa MSB into APU

    rla                         ; position 7-bit exponent for sign
    rl (hl)                     ; get sign
    rra
    AM9511_OUT_APU_DATA         ; load exponent into APU

    exx
    ret

.asm_am9511_max
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    ld a,0ffh                    ; confirm we have maximum
    AM9511_OUT_APU_DATA          ; load mantissa into APU
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA

    ld a,0feh                   ; position exponent for sign
    rl (hl)                     ; get sign
    rra
    AM9511_OUT_APU_DATA         ; load maximum exponent into APU

    exx
    ret

.asm_am9511_zero
    AM9511_IN_APU_DATA
    AM9511_IN_APU_DATA
    xor a                       ; confirm we have a zero
    AM9511_OUT_APU_DATA         ; load zero mantissa into APU
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA
    AM9511_OUT_APU_DATA         ; load zero exponent into APU

    exx
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
    ; uses  : af, bc, hl

    ld a,d                      ; capture exponent
    sla e                       ; position exponent in a
    rl a                        ; check for zero
    jr Z,asm_am9511_zero_fastcall
    cp 127+63                   ; check for overflow
    jr NC,asm_am9511_max_fastcall
    cp 127-64                   ; check for underflow
    jr C,asm_am9511_zero_fastcall
    sub 127-1                   ; bias including shift binary point

    rla                         ; position 7-bit exponent for sign
    rl d                        ; get sign
    rra
    ld d,a                      ; restore exponent

    scf                         ; set mantissa leading 1
    rr e                        ; restore mantissa

.pushf_fastcall
;   AM9511_IN_APU_STATUS      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jr C,pushf_fastcall

IFNDEF __AM9511_HELPER_FUNC
    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
ENDIF
    AM9511_OUTC l               ; load LSW into APU
    AM9511_OUTC h
    AM9511_OUTC e               ; load MSW into APU
    AM9511_OUTC d
    ret

.asm_am9511_zero_fastcall
    ld de,0                     ; no signed zero available
    ld h,d
    ld l,e
    jr pushf_fastcall

.asm_am9511_max_fastcall        ; floating max value of sign d in dehl
    ld a,d
    and 080h                    ; isolate sign
    or 03fh                     ; max exponent
    ld d,a

    ld e, 0ffh                  ; max mantissa
    ld h,e
    ld l,e
    jr pushf_fastcall

