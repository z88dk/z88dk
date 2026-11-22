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
; asm_am9511_fsub - am9511 floating point subtract
;-------------------------------------------------------------------------
; x - y via APU FSUB.  IEEE specials: treat as x + (−y) using add specials.
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
EXTERN asm_am9511_spec_add

PUBLIC asm_am9511_fsub, asm_am9511_fsub_callee


.asm_am9511_fsub
    ld a,d
    xor 080h
    ld d,a                          ; y := −y for IEEE specials
    call asm_am9511_spec_add
    ret C
    ld a,d
    xor 080h
    ld d,a                          ; restore y for APU FSUB

    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FSUB
    AM9511_OUT_APU_CONTROL        ; x - y

    jp asm_am9511_popf


.asm_am9511_fsub_callee
    ld a,d
    xor 080h
    ld d,a
    call asm_am9511_spec_add
    jr NC,scal_apu
    pop bc
    pop af
    pop af
    push bc
    ret

.scal_apu
    ld a,d
    xor 080h
    ld d,a

    call asm_am9511_pushf

    call asm_am9511_pushf_fastcall

    ld a,__IO_APU_OP_FSUB
    AM9511_OUT_APU_CONTROL

    pop hl
    pop de
    ex (sp),hl

    jp asm_am9511_popf
