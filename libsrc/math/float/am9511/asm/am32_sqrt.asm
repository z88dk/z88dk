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
; asm_am9511_sqrt - am9511 floating point square root
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
EXTERN asm_am9511_spec_sqrt

PUBLIC asm_am9511_sqrt, asm_am9511_sqrt_fastcall


; stack = x, ret  (x not consumed)
.asm_am9511_sqrt
    pop bc
    pop hl
    pop de                      ; DEHL = x
    push de
    push hl
    push bc                     ; x and ret restored
    call asm_am9511_spec_sqrt
    ret C

    call asm_am9511_pushf       ; x from stack

    ld a,__IO_APU_OP_SQRT
    AM9511_OUT_APU_CONTROL

    jp asm_am9511_popf


.asm_am9511_sqrt_fastcall
    call asm_am9511_spec_sqrt
    ret C

    call asm_am9511_pushf_fastcall

    ld a,__IO_APU_OP_SQRT
    AM9511_OUT_APU_CONTROL

    jp asm_am9511_popf
