;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_frexp - z80, z180, z80n fraction and exponent
;-------------------------------------------------------------------------
;
;   float m32_frexpf (float x, int *pw2)
;   {
;       union float_long fl;
;       int8_t i;
;
;       fl.f = x;
;       /* Find the exponent (power of 2) */
;       i  = ( fl.l >> 23) & 0x000000ff;
;       i -= 0x7e;
;       *pw2 = i;
;       fl.l &= 0x807fffff; /* strip all exponent bits */
;       fl.l |= 0x3f000000; /* mantissa between 0.5 and 1 */
;       return(fl.f);
;   }
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsfrexp_callee
PUBLIC _m32_frexpf


; float frexpf (float x, int *pw2);
._m32_frexpf
.m32_fsfrexp_callee
    ; evaluation of fraction and exponent
    ;
    ; enter : stack = float *pw2, float x, ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    pop af                      ; return
    pop hl                      ; (float)x in dehl
    pop de
    pop bc                      ; (int8_t*)pw2
    push af                     ; return on stack

    sla e                       ; get the exponent
    rl d
    rr e                        ; save the sign in e[7]

    ld a,d
    ld d,0
    and a
    jr Z,zero
    ld d,$7e                    ; remove exponent excess (bias-1)
    sub d                       ; mantissa between 0.5 and 1

.zero
    ld (bc),a                   ; and store in pw2
    inc bc
    rlca
    sbc  a
    ld  (bc),a

    rl e                        ; get sign back
    rr d
    rr e
    ret                         ; return IEEE DEHL fraction
