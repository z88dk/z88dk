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
;  asm_am9511_pushl - am9511 APU push long
;-------------------------------------------------------------------------
; 
;  Load long into Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_pushl
PUBLIC asm_am9511_pushl_fastcall


.asm_am9511_pushl

    ; float primitive
    ; push a long into Am9511 stack.
    ;
    ; enter : stack = long, ret1, ret0
    ;
    ; exit  : stack = long, ret1
    ; 
    ; uses  : af, bc

;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? __IO_APU_STATUS_BUSY
;   jp C,asm_am9511_pushl_hl

    ld bc,de                    ; preserve dehl

    ld de,sp+4

    ld a,(de)                   ; load LSW into APU
    out (__IO_APU_DATA),a
    inc de
    ld a,(de)
    out (__IO_APU_DATA),a

    inc de
    ld a,(de)                   ; load MSW into APU
    out (__IO_APU_DATA),a
    inc de
    ld a,(de)
    out (__IO_APU_DATA),a

    ld de,bc                    ; recover dehl
    ret


.asm_am9511_pushl_fastcall

    ; float primitive
    ; push a long into Am9511 stack.
    ;
    ; enter : stack = ret1, ret0
    ;       :  dehl = long
    ;
    ; exit  : stack = ret1
    ; 
    ; uses  : af, de, hl

;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? __IO_APU_STATUS_BUSY
;   jp C,asm_am9511_pushl_fastcall

    ld a,l                      ; load LSW into APU
    out (__IO_APU_DATA),a
    ld a,h
    out (__IO_APU_DATA),a

    ld a,e                      ; load MSW into APU
    out (__IO_APU_DATA),a
    ld a,d
    out (__IO_APU_DATA),a

    ret

