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
; asm_am9511_fdiv - am9511 floating point divide
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
EXTERN asm_am9511_spec_div

PUBLIC asm_am9511_fdiv, asm_am9511_fdiv_callee


; enter: stack = x, ret; DEHL = y → DEHL = x/y
.asm_am9511_fdiv
    call asm_am9511_spec_div
    ret C                           ; IEEE special handled

    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL        ; x / y

    jp asm_am9511_popf


; enter: stack = x, ret; DEHL = y; consumes x
.asm_am9511_fdiv_callee
    call asm_am9511_spec_div
    jr NC,dcal_apu
    pop bc                          ; ret
    pop af
    pop af                          ; drop x
    push bc
    ret

.dcal_apu
    call asm_am9511_pushf           ; x

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL        ; x / y

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popf
