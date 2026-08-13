;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, August 2020 / specials 2026
;
;-------------------------------------------------------------------------
; asm_am9511_fmul - am9511 floating point multiply
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf
EXTERN asm_am9511_spec_mul

PUBLIC asm_am9511_fmul, asm_am9511_fmul_callee


.asm_am9511_fmul
    call asm_am9511_spec_mul
    ret C

    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FMUL
    AM9511_OUT_APU_CONTROL        ; x * y

    jp asm_am9511_popf


.asm_am9511_fmul_callee
    call asm_am9511_spec_mul
    jr NC,mcal_apu
    pop bc
    pop af
    pop af
    push bc
    ret

.mcal_apu
    call asm_am9511_pushf

    call asm_am9511_pushf_fastcall

    ld a,__IO_APU_OP_FMUL
    AM9511_OUT_APU_CONTROL

    pop hl
    pop de
    ex (sp),hl

    jp asm_am9511_popf
