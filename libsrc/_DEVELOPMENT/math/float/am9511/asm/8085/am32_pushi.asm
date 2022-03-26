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
;  asm_am9511_pushi - am9511 APU push integer
;-------------------------------------------------------------------------
; 
;  Load integer into Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_pushi
PUBLIC asm_am9511_pushi_fastcall


.asm_am9511_pushi

    ; float primitive
    ; push an integer into Am9511 stack.
    ;
    ; enter : stack = integer, ret1, ret0
    ;
    ; exit  : stack = integer, ret1
    ; 
    ; uses  : af, bc

;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? __IO_APU_STATUS_BUSY
;   jp C,asm_am9511_pushi_hl

    ld bc,de                    ; preserve dehl

    ld de,sp+4

    ld a,(de)                   ; load LSW into APU
    out (__IO_APU_DATA),a
    inc de
    ld a,(de)
    out (__IO_APU_DATA),a

    ld de,bc                    ; recover dehl
    ret


.asm_am9511_pushi_fastcall

    ; float primitive
    ; push an integer into Am9511 stack.
    ;
    ; enter : stack = ret1, ret0
    ;       :    hl = integer
    ;
    ; exit  : stack = ret1
    ; 
    ; uses  : af, hl

;   in a,(__IO_APU_STATUS)      ; read the APU status register
;   rlca                        ; busy? __IO_APU_STATUS_BUSY
;   jp C,asm_am9511_pushi_fastcall

    ld a,l                      ; load LSW into APU
    out (__IO_APU_DATA),a
    ld a,h
    out (__IO_APU_DATA),a

    ret

