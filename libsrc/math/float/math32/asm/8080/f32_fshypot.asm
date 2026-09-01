;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8080 m32_fshypot — hypotf(x,y) = sqrt(sqr(x)+sqr(y))
; Same control as 8085.  x from stack via m32_fsload (HL pointer).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fssqr_fastcall
EXTERN m32_fssqrt_fastcall
EXTERN m32_fsadd_callee
EXTERN m32_fsload

PUBLIC m32_fshypot
PUBLIC m32_fshypot_callee


.m32_fshypot
    call m32_fssqr_fastcall         ; in DEHL=y; out DEHL=sqr(y)
    push de
    push hl                         ; SP: sqr(y), ret, x
    ld hl,sp+6                      ; HL = &x
    call m32_fsload                 ; in HL=ptr; out DEHL=x
    call m32_fssqr_fastcall         ; DEHL = sqr(x)
    call m32_fsadd_callee           ; in DEHL=sqr(x), stack sqr(y); out DEHL=sum
    call m32_fssqrt_fastcall        ; DEHL = hypot
    or a
    ret


.m32_fshypot_callee
    call m32_fssqr_fastcall         ; in DEHL=y; out DEHL=sqr(y)
    push de
    push hl
    ld hl,sp+6
    call m32_fsload                 ; DEHL = x
    call m32_fssqr_fastcall         ; DEHL = sqr(x)
    call m32_fsadd_callee           ; DEHL = sqr(x)+sqr(y)
    call m32_fssqrt_fastcall        ; DEHL = hypot
    pop bc
    pop af
    pop af
    push bc
    or a
    ret
