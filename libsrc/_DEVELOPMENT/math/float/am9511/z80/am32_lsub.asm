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
; asm_am9511_lsub - am9511 long subtract
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_DSUB

EXTERN asm_am9511_pushl
EXTERN asm_am9511_pushl_fastcall
EXTERN asm_am9511_popl

PUBLIC asm_am9511_lsub, asm_am9511_lsub_callee


; enter here for long subtract, x-y x on stack, y in dehl
.asm_am9511_lsub
    exx
    ld hl,2
    add hl,sp
    call asm_am9511_pushl           ; x

    exx
    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DSUB
    out (__IO_APU_CONTROL),a        ; x - y

    jp asm_am9511_popl


; enter here for long subtract callee, x-y x on stack, y in dehl
.asm_am9511_lsub_callee
    exx
    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack
    ex de,hl
    call asm_am9511_pushl_fastcall  ; x

    exx
    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DSUB
    out (__IO_APU_CONTROL),a        ; x - y

    jp asm_am9511_popl
