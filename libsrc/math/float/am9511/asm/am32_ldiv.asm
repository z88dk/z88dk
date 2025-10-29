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
; asm_am9511_ldiv - am9511 long divide
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushl
EXTERN asm_am9511_pushl_fastcall
EXTERN asm_am9511_popl

PUBLIC asm_am9511_ldiv, asm_am9511_ldiv_callee


; enter here for long divide, x/y, x on stack, y in dehl
.asm_am9511_ldiv
    call asm_am9511_pushl           ; x

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DDIV
    AM9511_OUT_APU_CONTROL        ; x / y

    jp asm_am9511_popl              ; quotient in dehl


; enter here for long divide callee, x/y, x on stack, y in dehl
.asm_am9511_ldiv_callee
    call asm_am9511_pushl           ; x

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DDIV
    AM9511_OUT_APU_CONTROL        ; x / y

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popl              ; dividend in dehl
