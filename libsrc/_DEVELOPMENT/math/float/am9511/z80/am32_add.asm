;
;  feilipu, 2020 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; asm_am9511_add - am9511 floating point add
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_FADD

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_add, asm_am9511_add_callee


; enter here for floating add, x+y, x on stack, y in dehl, result in dehl
.asm_am9511_add
    push hl
    ld hl,6
    add hl,sp
    call asm_am9511_pushf           ; x
    pop hl
    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FADD
    out (__IO_APU_CONTROL),a        ; x + y

    jp asm_am9511_popf


; enter here for floating add callee, x+y, x on stack, y in dehl
.asm_am9511_add_callee
    push hl
    ld hl,6
    add hl,sp
    call asm_am9511_pushf           ; x
    pop hl
    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FADD
    out (__IO_APU_CONTROL),a        ; x + y

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popf

