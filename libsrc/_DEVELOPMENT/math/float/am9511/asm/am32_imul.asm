;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, February 2022
;
;-------------------------------------------------------------------------
; asm_am9511_imul - z80 integer multiply - long result
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

IFDEF __CLASSIC
INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"
ELSE
INCLUDE "target/am9511/config_am9511_private.inc"
ENDIF

EXTERN asm_am9511_pushl_fastcall
EXTERN asm_am9511_popi

PUBLIC asm_am9511_imul


; enter here for integer multiply, x*y x in de, y in hl, result in dehl
.asm_am9511_imul
    call asm_am9511_pushl_fastcall  ; x,y

    ld a,__IO_APU_OP_PTOD
    out (__IO_APU_CONTROL),a        ; x,y, x,y

    ld a,__IO_APU_OP_SMUU
    out (__IO_APU_CONTROL),a        ; x * y (upper)

    call asm_am9511_popi            ; upper product in hl

    ld a,__IO_APU_OP_SMUL
    out (__IO_APU_CONTROL),a        ; x * y (lower)

    ex de,hl
    jp asm_am9511_popi              ; product in dehl

