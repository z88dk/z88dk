;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_hypot - z80, z180, z80n hypotenuse evaluation
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
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fssqr_fastcall, m32_fssqrt_fastcall, m32_fsadd_callee

PUBLIC m32_fshypot, m32_fshypot_callee

.m32_fshypot

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

    call m32_fssqr_fastcall     ; sqrf(y)

    exx
    pop bc                      ; return
    pop hl                      ; (float) x in dehl
    pop de
    push de
    push hl
    push bc                     ; return on stack

    exx
    push de                     ; sqrf(y) on stack
    push hl
    jr rejoin


.m32_fshypot_callee

    ; evaluation of a hypotenuse function
    ;
    ; enter : stack = float x, ret
    ;         dehl  = float y
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'


    call m32_fssqr_fastcall     ; sqrf(y)

    exx
    pop bc                      ; return
    pop hl                      ; (float) x in dehl
    pop de
    push bc                     ; return on stack

    exx
    push de                     ; sqrf(y) on stack
    push hl

.rejoin
    exx
    call m32_fssqr_fastcall     ; sqrf(x)
    call m32_fsadd_callee       ; sqrf(y) + sqrf(x)
    call m32_fssqrt_fastcall
    ret

