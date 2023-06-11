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
; asm_am9511_fdiv - am9511 floating point divide
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_fdiv, asm_am9511_fdiv_callee


; enter here for floating divide, x/y, x on stack, y in dehl, result in dehl
.asm_am9511_fdiv
    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; x / y

    jp asm_am9511_popf


; enter here for floating divide callee, x/y, x on stack, y in dehl
.asm_am9511_fdiv_callee
    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; x / y

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popf
