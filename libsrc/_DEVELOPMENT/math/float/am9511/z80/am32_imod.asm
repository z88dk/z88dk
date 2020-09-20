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
; asm_am9511_imod - am9511 integer modulus - mod(x,y)= x-y*int(x/y)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_SDIV
EXTERN __IO_APU_OP_SMUL
EXTERN __IO_APU_OP_SSUB
EXTERN __IO_APU_OP_PTOS

EXTERN asm_am9511_pushi_hl
EXTERN asm_am9511_pushi_fastcall
EXTERN asm_am9511_popi

PUBLIC asm_am9511_imod, asm_am9511_imod_callee


; enter here for integer modulus, x+y, x on stack, y in hl
.asm_am9511_imod
    exx
    ld hl,2
    add hl,sp
    call asm_am9511_pushi_hl        ; x

    ld a,__IO_APU_OP_PTOS
    out (__IO_APU_CONTROL),a        ; push x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SDIV
    out (__IO_APU_CONTROL),a

    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SMUL
    out (__IO_APU_CONTROL),a

    ld a,__IO_APU_OP_SSUB
    out (__IO_APU_CONTROL),a        ; x%y

    jp asm_am9511_popi              ; remainder in hl


; enter here for integer modulus callee, x+y, x on stack, y in hl
.asm_am9511_imod_callee
    exx
    pop hl                          ; ret
    ex (sp),hl                      ; ret back on stack
    call asm_am9511_pushi_fastcall  ; x

    ld a,__IO_APU_OP_PTOS
    out (__IO_APU_CONTROL),a        ; push x

    exx
    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SDIV
    out (__IO_APU_CONTROL),a

    call asm_am9511_pushi_fastcall  ; y

    ld a,__IO_APU_OP_SMUL
    out (__IO_APU_CONTROL),a

    ld a,__IO_APU_OP_SSUB
    out (__IO_APU_CONTROL),a        ; x%y

    jp asm_am9511_popi              ; remainder in hl
