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

SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_discardfraction

EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_ceil_fastcall

; Entry: dehl = floating point number
.asm_am9511_ceil_fastcall
    call asm_am9511_discardfraction
    ld a,d
    rla
    ret C

.was_positive
    ; Add 1
    call asm_am9511_pushf_fastcall  ; x
    ld de,$3f80
    ld hl,$0000
    call asm_am9511_pushf_fastcall  ; y
    
    ld a,__IO_APU_OP_FADD
    out (__IO_APU_CONTROL),a        ; x + y

    jp asm_am9511_popf

