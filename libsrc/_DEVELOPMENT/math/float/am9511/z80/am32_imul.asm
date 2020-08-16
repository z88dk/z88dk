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
; asm_am9511_imul - z80 integer multiply
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_SMUL

EXTERN asm_am9511_pushi
EXTERN asm_am9511_pushi_fastcall
EXTERN asm_am9511_popi

PUBLIC asm_am9511_imul, asm_am9511_imul_callee


; enter here for integer multiply, x-y x on stack, y in hl
.asm_am9511_imul
    exx
    ld hl,2
    add hl,sp
    call asm_am9511_pushi           ; x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SMUL
    out (__IO_APU_CONTROL),a        ; x * y

    jp asm_am9511_popi              ; product in hl


; enter here for integer multiply callee, x-y x on stack, y in hl
.asm_am9511_imul_callee
    exx
    pop hl                          ; ret
    ex (sp),hl                      ; ret back on stack
    call asm_am9511_pushi_fastcall  ; x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SMUL
    out (__IO_APU_CONTROL),a        ; x * y

    jp asm_am9511_popi              ; product in hl
