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
;  asm_am9511_popl - am9511 APU pop long
;-------------------------------------------------------------------------
; 
;  Load long from Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

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
    ; uses  : af, bc, de, hl

    in a,(__IO_APU_STATUS)      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jr C,am9511_popl_wait

    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
    in d,(c)                    ; load MSW from APU
    in e,(c)
    in h,(c)                    ; load LSW from APU
    in l,(c)
    ret

