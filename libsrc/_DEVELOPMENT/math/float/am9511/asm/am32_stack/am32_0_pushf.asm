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
;  asm_am9511_0_pushf - am9511 APU push float
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

PUBLIC asm_am9511_0_pushf_hl
PUBLIC asm_am9511_0_pushf_fastcall

PUBLIC asm_am9511_pushf_zero
PUBLIC asm_am9511_pushf_max

PUBLIC asm_am9511_pushf_rejoin_fastcall
PUBLIC asm_am9511_pushf_zero_fastcall
PUBLIC asm_am9511_pushf_max_fastcall

.am9511_0_pushf_hl_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_0_pushf_hl

    ; float primitive
    ; push a IEEE-754 floating point into Am9511 stack.
    ;
    ; Convert from IEEE_float to am9511_float.
    ;
    ; enter : stack = IEEE_float, ret1, ret0
    ;       :    hl = pointer to IEEE_float
    ;
    ; exit  : stack = IEEE_float, ret1
    ;
    ; uses  : af, bc, hl

    in a,(__IO_APU0_STATUS)     ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jr C,am9511_0_pushf_hl_wait

    ld bc,__IO_APU0_DATA        ; the address of the APU data port in bc
    outi                        ; load LSW into APU
    inc b
    outi
    inc b

    ld a,(hl)                   ; get mantissa MSB
    rla                         ; get exponent least significant bit to carry
    inc hl
    ld a,(hl)                   ; get exponent to a
    rl a                        ; get all exponent to a, set flags
    jr Z,asm_am9511_pushf_zero        ; check for zero
    cp 127+63                   ; check for overflow
    jr NC,asm_am9511_pushf_max
    cp 127-64                   ; check for underflow
    jr C,asm_am9511_pushf_zero
    sub 127-1                   ; bias including shift binary point

    dec hl
    set 7,(hl)                  ; set mantissa MSB
    outi                        ; load mantissa MSB into APU
    inc b
    
    rla                         ; position exponent for sign
    rl (hl)                     ; get sign
    rra
    out (c),a                   ; load exponent into APU
    ret

.asm_am9511_pushf_max
    dec hl
    bit 7,(hl)                  ; set mantissa MSB
    outi                        ; load mantissa MSB into APU
    inc b
    
    ld a,0FEh                   ; position exponent for sign
    rl (hl)                     ; get sign
    rra
    out (c),a                   ; load maximum exponent into APU
    ret

.asm_am9511_pushf_zero
    in a,(c)
    in a,(c)
    xor a                       ; confirm we have a zero
    out (c),a                   ; load zero mantissa into APU
    out (c),a
    out (c),a
    out (c),a                   ; load zero exponent into APU
    ret

.am9511_0_pushf_fastcall_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_0_pushf_fastcall

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
    ; uses  : af, bc, de, hl

    in a,(__IO_APU0_STATUS)     ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jr C,am9511_0_pushf_fastcall_wait

    ld bc,__IO_APU0_DATA        ; the address of the APU data port in bc

    ld a,d                      ; capture exponent
    sla e                       ; position exponent in a
    rl a                        ; check for zero
    jr Z,asm_am9511_pushf_zero_fastcall
    cp 127+63                   ; check for overflow
    jr NC,asm_am9511_pushf_max_fastcall
    cp 127-64                   ; check for underflow
    jr C,asm_am9511_pushf_zero_fastcall
    sub 127-1                   ; bias including shift binary point

    rla                         ; position exponent for sign
    rl d                        ; get sign
    rra
    ld d,a                      ; restore exponent

    scf                         ; set mantissa leading 1
    rr e                        ; restore mantissa

.asm_am9511_pushf_rejoin_fastcall
    out (c),l                   ; load LSW into APU
    out (c),h
    out (c),e                   ; load MSW into APU
    out (c),d
    ret

.asm_am9511_pushf_max_fastcall  ; floating max value of sign d in dehl
    ld a,d
    and 080h                    ; isolate sign
    or 03fh                     ; max exponent
    ld d,a

    ld e, 0ffh                  ; max mantissa
    ld h,e
    ld l,e
    jp asm_am9511_pushf_rejoin_fastcall

.asm_am9511_pushf_zero_fastcall
    ld de,0                     ; no signed zero available
    ld h,d
    ld l,e
    jp asm_am9511_pushf_rejoin_fastcall


