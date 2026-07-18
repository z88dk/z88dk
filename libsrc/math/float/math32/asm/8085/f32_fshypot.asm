;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fshypot — hypotf(x,y) = sqrt(sqr(x)+sqr(y))
; Stack only (no BSS, no exx). Keep ret on stack (callees clobber BC).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fssqr_fastcall
EXTERN m32_fssqrt_fastcall
EXTERN m32_fsadd_callee

PUBLIC m32_fshypot
PUBLIC m32_fshypot_callee


; enter: stack = float x, ret; DEHL = float y
; exit:  stack = float x, ret; DEHL = hypot
.m32_fshypot
    call m32_fssqr_fastcall         ; DEHL = sqr(y)
    ; SP: ret, x
    push de
    push hl                         ; SP: sqr(y), ret, x
    ; x at SP+6
    ld de,sp+6
    call load_float_de              ; DEHL = x
    call m32_fssqr_fastcall
    call m32_fsadd_callee           ; drops sqr(y); SP: ret, x
    call m32_fssqrt_fastcall
    or a
    ret                             ; leave x under ret


; enter: stack = float x, ret; DEHL = float y
; exit:  DEHL = hypot (x consumed)
.m32_fshypot_callee
    call m32_fssqr_fastcall         ; DEHL = sqr(y)
    ; SP: ret, x
    push de
    push hl                         ; SP: sqr(y), ret, x
    ld de,sp+6
    call load_float_de
    call m32_fssqr_fastcall
    call m32_fsadd_callee           ; SP: ret, x
    call m32_fssqrt_fastcall
    ; drop x under ret: pop ret, drop x, push ret
    pop bc                          ; ret
    pop af
    pop af                          ; drop x
    push bc
    or a
    ret


.load_float_de
    push de
    pop hl
    ld bc,(hl+)
    ld de,(hl+)
    ld hl,bc
    ret
