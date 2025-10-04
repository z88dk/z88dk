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
; asm_am9511_log10 - am9511 floating point log10
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/newlib/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_log10, asm_am9511_log10_fastcall


.asm_am9511_log10
    call asm_am9511_pushf           ; x

    ld a,__IO_APU_OP_LOG
    AM9511_OUT_APU_CONTROL        ; log10(x)

    jp asm_am9511_popf


.asm_am9511_log10_fastcall
    call asm_am9511_pushf_fastcall  ; x

    ld a,__IO_APU_OP_LOG
    AM9511_OUT_APU_CONTROL        ; log10(x)

    jp asm_am9511_popf

