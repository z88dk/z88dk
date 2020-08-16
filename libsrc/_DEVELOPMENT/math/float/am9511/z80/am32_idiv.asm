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
; asm_am9511_idiv - am9511 integer divide
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_SDIV

EXTERN asm_am9511_pushi
EXTERN asm_am9511_pushi_fastcall
EXTERN asm_am9511_popi

PUBLIC asm_am9511_idiv, asm_am9511_idiv_callee


; enter here for integer divide, x+y, x on stack, y in hl
.asm_am9511_idiv
    exx
    ld hl,2
    add hl,sp
    call asm_am9511_pushi           ; x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SDIV
    out (__IO_APU_CONTROL),a        ; x / y

    jp asm_am9511_popi              ; quotient in hl


; enter here for integer divide callee, x+y, x on stack, y in hl
.asm_am9511_idiv_callee
    exx
    pop hl                          ; ret
    ex (sp),hl                      ; ret back on stack
    call asm_am9511_pushi_fastcall  ; x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SDIV
    out (__IO_APU_CONTROL),a        ; x / y

    jp asm_am9511_popi              ; quotient in hl
