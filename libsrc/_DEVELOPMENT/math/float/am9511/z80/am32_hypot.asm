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
; asm_am9511_hypot - z80, z180, z80n hypotenuse evaluation
;-------------------------------------------------------------------------
;
; The hypotenuse is the longest side of a right-angled triangle.
; The hypotf() function is used to find hypotenuse when
; other two sides are provided.
; 
; float hypotf(float x, float y)
; {
;   return sqrtf( sqrf(x) + sqrf(y);
; }
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

EXTERN __IO_APU_CONTROL
EXTERN __IO_APU_OP_PTOF
EXTERN __IO_APU_OP_FADD
EXTERN __IO_APU_OP_FMUL
EXTERN __IO_APU_OP_SQRT

EXTERN asm_am9511_pushf
EXTERN asm_am9511_pushf_fastcall
EXTERN asm_am9511_popf

PUBLIC asm_am9511_hypot, asm_am9511_hypot_callee

.asm_am9511_hypot

    ; evaluation of a hypotenuse function
    ;
    ; enter : stack = float x, ret
    ;         dehl  = float y
    ;
    ; exit  : stack = float x, ret
    ;         dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_PTOF
    out (__IO_APU_CONTROL),a        ; y

    ld a,__IO_APU_OP_FMUL
    out (__IO_APU_CONTROL),a        ; y * y

    ld hl,2
    add hl,sp
    call asm_am9511_pushf           ; x

    ld a,__IO_APU_OP_PTOF
    out (__IO_APU_CONTROL),a        ; x

    ld a,__IO_APU_OP_FMUL
    out (__IO_APU_CONTROL),a        ; x * x

    ld a,__IO_APU_OP_FADD
    out (__IO_APU_CONTROL),a        ; y^2 + x^2

    ld a,__IO_APU_OP_SQRT
    out (__IO_APU_CONTROL),a        ; (y^2 + x^2)^0.5

    jp asm_am9511_popf

.asm_am9511_hypot_callee

    ; evaluation of a hypotenuse function
    ;
    ; enter : stack = float x, ret
    ;         dehl  = float y
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    call asm_am9511_pushf_fastcall  ; y

    ld a,__IO_APU_OP_PTOF
    out (__IO_APU_CONTROL),a        ; y

    ld a,__IO_APU_OP_FMUL
    out (__IO_APU_CONTROL),a        ; y * y

    ld hl,2
    add hl,sp
    call asm_am9511_pushf           ; x

    ld a,__IO_APU_OP_PTOF
    out (__IO_APU_CONTROL),a        ; x

    ld a,__IO_APU_OP_FMUL
    out (__IO_APU_CONTROL),a        ; x * x

    ld a,__IO_APU_OP_FADD
    out (__IO_APU_CONTROL),a        ; y^2 + x^2

    ld a,__IO_APU_OP_SQRT
    out (__IO_APU_CONTROL),a        ; (y^2 + x^2)^0.5

    pop hl                          ; ret
    pop de
    ex (sp),hl                      ; ret back on stack

    jp asm_am9511_popf

