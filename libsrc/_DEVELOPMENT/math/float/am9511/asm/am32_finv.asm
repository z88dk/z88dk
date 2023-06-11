;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------
; asm_am9511_finv - am9511 floating point inverse
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

PUBLIC asm_am9511_finv, asm_am9511_finv_fastcall


; enter here for floating inverse, 1/x, x on stack, result in dehl
.asm_am9511_finv

    ld de,03f80h
    ld hl,0

    call asm_am9511_pushf_fastcall  ; 1

    call asm_am9511_pushf           ; x

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; 1 / x

    jp asm_am9511_popf


; enter here for floating inverse fastcall, 1/x, x in dehl, result in dehl
.asm_am9511_finv_fastcall
    call asm_am9511_pushf_fastcall  ; x

    ld de,03f80h
    ld hl,0h

    call asm_am9511_pushf_fastcall  ; 1

    ld a,__IO_APU_OP_XCHF
    out (__IO_APU_CONTROL),a        ; swap

    ld a,__IO_APU_OP_FDIV
    out (__IO_APU_CONTROL),a        ; 1 / x

    jp asm_am9511_popf
