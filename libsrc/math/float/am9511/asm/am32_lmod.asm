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
; asm_am9511_lmod - am9511 long modulus - mod(x,y)= x-y*int(x/y)
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

PUBLIC asm_am9511_lmod, asm_am9511_lmod_callee


; enter here for long modulus, x%y, x on stack, y in dehl
.asm_am9511_lmod
    call asm_am9511_pushl           ; x

    ld a,__IO_APU_OP_PTOD
    AM9511_OUT_APU_CONTROL        ; push x

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DDIV
    AM9511_OUT_APU_CONTROL

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DMUL
    AM9511_OUT_APU_CONTROL

    ld a,__IO_APU_OP_DSUB
    AM9511_OUT_APU_CONTROL        ; x%y

    jp asm_am9511_popl              ; remainder in dehl


; enter here for long modulus callee, x%y, x on stack, y in dehl
.asm_am9511_lmod_callee
    call asm_am9511_pushl           ; x

    ld a,__IO_APU_OP_PTOD
    AM9511_OUT_APU_CONTROL        ; push x

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DDIV
    AM9511_OUT_APU_CONTROL

    call asm_am9511_pushl_fastcall  ; y

    ld a,__IO_APU_OP_DMUL
    AM9511_OUT_APU_CONTROL

    ld a,__IO_APU_OP_DSUB
    AM9511_OUT_APU_CONTROL        ; x%y

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popl              ; remainder in dehl
