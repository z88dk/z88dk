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
; asm_am9511_inv - am9511 floating point inverse
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_FDIV

EXTERN asm_am9511_pushf_hl
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_inv, asm_am9511_inv_fastcall


; enter here for floating inverse, 1/x, x on stack, result in dehl
.asm_am9511_inv
    ld de,03F80h
    ld hl,0
    call asm_am9511_pushf_fastcall  ; 1

    ld hl,2
    add hl,sp
    call asm_am9511_pushf_hl        ; x

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; 1/x

    jp asm_am9511_popf


; enter here for floating inverse fastcall, 1/x, x in dehl, result in dehl
.asm_am9511_inv_fastcall
    exx
    ld de,03F80h
    ld hl,0
    call asm_am9511_pushf_fastcall  ; 1

    exx
    call asm_am9511_pushf_fastcall  ; x

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; 1/x

    jp asm_am9511_popf
