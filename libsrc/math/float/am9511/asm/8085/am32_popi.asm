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
;  asm_am9511_popi - am9511 APU pop integer
;-------------------------------------------------------------------------
; 
;  Load integer from Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_popi


.am9511_popi_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_popi

    ; float primitive
    ; pop an integer from the Am9511 stack.
    ;
    ; enter : stack = ret0
    ;
    ; exit  :  dehl = integer
    ; 
    ; uses  : af, de, hl

    AM9511_IN_APU_STATUS      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jp C,am9511_popi_wait

    AM9511_IN_APU_DATA        ; load LSW from APU
    ld h,a
    AM9511_IN_APU_DATA
    ld l,a

    ret

