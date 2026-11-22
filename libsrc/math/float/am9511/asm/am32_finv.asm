;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022 / specials 2026
;
;-------------------------------------------------------------------------
; asm_am9511_finv - am9511 floating point inverse (1/x)
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

PUBLIC asm_am9511_finv, asm_am9511_finv_fastcall


; stack = x, ret (x not consumed)
.asm_am9511_finv
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc                     ; DEHL = x; stack restored
    call finv_spec
    ret C
    ld de,03f80h
    ld hl,0
    call asm_am9511_pushf_fastcall  ; 1
    call asm_am9511_pushf           ; x
    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL
    jp asm_am9511_popf


.asm_am9511_finv_fastcall
    call finv_spec
    ret C
    call asm_am9511_pushf_fastcall  ; x
    ld de,03f80h
    ld hl,0
    call asm_am9511_pushf_fastcall  ; 1
    ld a,__IO_APU_OP_XCHF
    AM9511_OUT_APU_CONTROL
    ld a,__IO_APU_OP_FDIV
    AM9511_OUT_APU_CONTROL
    jp asm_am9511_popf


; DEHL = x.  CF=1 if handled.
.finv_spec
    ld a,e
    add a,a
    ld a,d
    adc a,a
    or a
    jr Z,finv_0
    inc a
    jr Z,finv_255
    or a                        ; CF=0 finite
    ret

.finv_0
    ld a,d
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    ret

.finv_255
    ld a,e
    and 07fh
    or h
    or l
    jr NZ,finv_nan
    ld a,d
    and 080h
    ld d,a
    ld e,0
    ld h,e
    ld l,e
    scf
    ret

.finv_nan
    ld de,07fffh
    ld h,e
    ld l,e
    scf
    ret
