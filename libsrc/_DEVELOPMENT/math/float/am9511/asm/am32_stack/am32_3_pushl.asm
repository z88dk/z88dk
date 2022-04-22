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
;  asm_am9511_3_pushl - am9511 APU push long
;-------------------------------------------------------------------------
; 
;  Load long into Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

PUBLIC asm_am9511_3_pushl_hl
PUBLIC asm_am9511_3_pushl_fastcall

.am9511_3_pushl_hl_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_3_pushl_hl

    ; float primitive
    ; push a long into Am9511 stack.
    ;
    ; enter : stack = ret1, ret0
    ;       :    hl = pointer to long
    ;
    ; exit  : stack = long, ret1
    ; 
    ; uses  : af, bc, hl

    in a,(__IO_APU3_STATUS)     ; read the APU status register
    rlca                        ; busy? __IO_APU_STATUS_BUSY
    jr C,am9511_3_pushl_hl_wait

    ld bc,__IO_APU3_DATA        ; the address of the APU data port in bc
    outi                        ; load LSW into APU
    inc b
    outi
    inc b
    outi                        ; load MSW into APU
    inc b
    outi
    ret

.am9511_3_pushl_fastcall_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_3_pushl_fastcall

    ; float primitive
    ; push a long into Am9511 stack.
    ;
    ; enter : stack = ret1, ret0
    ;       :  dehl = long
    ;
    ; exit  : stack = ret1
    ; 
    ; uses  : af, bc, de, hl

    in a,(__IO_APU3_STATUS)     ; read the APU status register
    rlca                        ; busy? __IO_APU_STATUS_BUSY
    jr C,am9511_3_pushl_fastcall_wait

    ld bc,__IO_APU3_DATA        ; the address of the APU data port in bc
    out (c),l                   ; load LSW into APU
    out (c),h
    out (c),e                   ; load MSW into APU
    out (c),d
    ret

