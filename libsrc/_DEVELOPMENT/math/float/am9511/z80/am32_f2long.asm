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

EXTERN asm_am9511_zero, asm_am9511_max

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_FIXD
EXTERN __IO_APU_OP_FIXS

EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popl
EXTERN asm_am9511_popi

PUBLIC asm_am9511_f2sint
PUBLIC asm_am9511_f2uint
PUBLIC asm_am9511_f2slong
PUBLIC asm_am9511_f2ulong


; Convert floating point number to int
asm_am9511_f2sint:
asm_am9511_f2uint:
    ld a,d                      ;Holds sign + 7bits of exponent
    rlc e
    rla                         ;a = Exponent
    and a
    jp Z,asm_am9511_zero        ;exponent was 0, return 0

    cp $7e + 16
    jp NC,asm_am9511_max        ;number too large

    rrc  e                      ; e register is rotated by bit, rotate back

    call asm_am9511_pushf_fastcall  ; float x

    ld a,__IO_APU_OP_FIXS
    out (__IO_APU_CONTROL),a        ; int x

    jp asm_am9511_popi


; Convert floating point number to long
asm_am9511_f2slong:
asm_am9511_f2ulong:
    ld a,d                      ;Holds sign + 7bits of exponent
    rlc e
    rla                         ;a = Exponent
    and a
    jp Z,asm_am9511_zero        ;exponent was 0, return 0

    cp $7e + 32
    jp NC,asm_am9511_max        ;number too large

    rrc  e                      ; e register is rotated by bit, rotate back

    call asm_am9511_pushf_fastcall  ; float x

    ld a,__IO_APU_OP_FIXD
    out (__IO_APU_CONTROL),a        ; long x

    jp asm_am9511_popl

