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
;  asm_am9511_popl - am9511 APU pop long
;-------------------------------------------------------------------------
; 
;  Load long from Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"

PUBLIC asm_am9511_popl


.am9511_popl_wait
    ex (sp),hl
    ex (sp),hl

.asm_am9511_popl

    ; float primitive
    ; pop a long from the Am9511 stack.
    ;
    ; enter : stack = ret0
    ;
    ; exit  :  dehl = long
    ; 
    ; uses  : af, de, hl

    in a,(__IO_APU_STATUS)      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jp C,am9511_popl_wait

    in a,(__IO_APU_DATA)        ; load MSW from APU
    ld d,a
    in a,(__IO_APU_DATA)
    ld e,a

    in a,(__IO_APU_DATA)        ; load LSW from APU
    ld h,a
    in a,(__IO_APU_DATA)
    ld l,a

    ret

