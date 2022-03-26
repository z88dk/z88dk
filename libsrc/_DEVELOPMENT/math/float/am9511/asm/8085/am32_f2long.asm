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

SECTION code_clib
SECTION code_fp_am9511

INCLUDE "../../_DEVELOPMENT/target/am9511/config_am9511_private.inc"

EXTERN asm_am9511_zero, asm_am9511_max

EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popl
EXTERN asm_am9511_popi

PUBLIC asm_am9511_f2sint
PUBLIC asm_am9511_f2uint
PUBLIC asm_am9511_f2slong
PUBLIC asm_am9511_f2ulong


; Convert floating point number to int
.asm_am9511_f2sint
.asm_am9511_f2uint
    ld a,e                      ;Holds sign + 7bits of exponent
    rla

    ld a,d                      ;a = Exponent
    rla
    or a
    jp Z,asm_am9511_zero        ;exponent was 0, return 0

    cp $7e + 16
    jp NC,asm_am9511_max        ;number too large

    call asm_am9511_pushf_fastcall  ;float x

    ld a,__IO_APU_OP_FIXS
    out (__IO_APU_CONTROL),a        ;int x

    jp asm_am9511_popi


; Convert floating point number to long
.asm_am9511_f2slong
.asm_am9511_f2ulong
    ld a,e                      ;Holds sign + 7bits of exponent
    rla

    ld a,d                      ;a = Exponent
    rla
    or a
    jp Z,asm_am9511_zero        ;exponent was 0, return 0

    cp $7e + 32
    jp NC,asm_am9511_max        ;number too large

    call asm_am9511_pushf_fastcall  ;float x

    ld a,__IO_APU_OP_FIXD
    out (__IO_APU_CONTROL),a        ;long x

    jp asm_am9511_popl

