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
;  asm_am9511_popi - am9511 APU pop integer
;-------------------------------------------------------------------------
; 
;  Load integer from Am9511 APU stack
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

EXTERN __IO_APU_STATUS, __IO_APU_DATA

PUBLIC asm_am9511_popi
PUBLIC _am9511_popi

._am9511_popi
.asm_am9511_popi

    ; float primitive
    ; pop a long from the Am9511 stack.
    ;
    ; enter : stack = ret0
    ;
    ; exit  :  dehl = integer
    ; 
    ; uses  : af, bc, hl

    in a,(__IO_APU_STATUS)      ; read the APU status register
    rlca                        ; busy? and __IO_APU_STATUS_BUSY
    jr C,asm_am9511_popi

    ld bc,__IO_APU_DATA         ; the address of the APU data port in bc
    in h,(c)                    ; load LSW from APU
    in l,(c)
    ret

