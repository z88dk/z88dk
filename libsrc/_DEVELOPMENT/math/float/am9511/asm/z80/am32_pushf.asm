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
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
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

;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jr C,asm_am9511_pushf

    exx                         ; preserve dehl

    ld hl,4
    add hl,sp

    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
    outi                        ; load LSW into APU
    outi

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
    outi                        ; load mantissa MSB into APU

    rla                         ; position 7-bit exponent for sign
    rl (hl)                     ; get sign
    rra
    out (c),a                   ; load exponent into APU

    exx
    ret

.asm_am9511_max
    in a,(c)
    in a,(c)
    ld a,0ffh                    ; confirm we have maximum
    out (c),a                    ; load mantissa into APU
    out (c),a
    out (c),a

    ld a,0feh                   ; position exponent for sign
    rl (hl)                     ; get sign
    rra
    out (c),a                   ; load maximum exponent into APU

    exx
    ret

.asm_am9511_zero
    in a,(c)
    in a,(c)
    xor a                       ; confirm we have a zero
    out (c),a                   ; load zero mantissa into APU
    out (c),a
    out (c),a
    out (c),a                   ; load zero exponent into APU

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
;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? and __IO_APU_STATUS_BUSY
;   jr C,pushf_fastcall

    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
    out (c),l                   ; load LSW into APU
    out (c),h
    out (c),e                   ; load MSW into APU
    out (c),d
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

