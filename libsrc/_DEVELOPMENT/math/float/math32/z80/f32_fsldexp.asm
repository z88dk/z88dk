;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_ldexp - z80, z180, z80n load exponent
;-------------------------------------------------------------------------
;
;   float m32_ldexpf (float x, int16_t pw2)
;   {
;       union float_long fl;
;       int32_t e;
;
;       fl.f = x;
;
;       e = (fl.l >> 23) & 0x000000ff;
;       e += pw2;
;       fl.l = ((e & 0xff) << 23) | (fl.l & 0x807fffff);
;
;       return(fl.f);
;   }
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmin

PUBLIC m32_dmulpow2

   ; multiply DEHL' by a power of two
   ; DEHL' *= 2^(HL)
   ;
   ; enter : DEHL'= float x
   ;         HL = signed integer
   ;
   ; exit  : success
   ;
   ;            DEHL'= x * 2^(HL)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'
   
.m32_dmulpow2
    push hl                     ; power 2 on stack
    exx
    pop bc                      ; power 2 in bc
    call pow2
    exx
    ret


PUBLIC m32_fsldexp_callee
PUBLIC _m32_ldexpf

; float ldexpf (float x, int16_t pw2);
._m32_ldexpf
.m32_fsldexp_callee
    ; evaluation of fraction and exponent
    ;
    ; enter : stack = int16_t pw2, float x, ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    pop af                      ; return
    pop hl                      ; (float)x in dehl
    pop de
    pop bc                      ; pw2 maximum int8_t actually
    push af                     ; return on stack

.pow2
    sla e                       ; get the exponent
    rl d
    jr Z,zero_legal             ; return IEEE signed zero
    rr e                        ; save the sign in e[7]

    ld a,d
    add c                       ; pw2
    ld d,a                      ; exponent returned

    sla e                       ; restore sign to C
    rr de

    and a                       ; check for zero exponent
    ret NZ                      ; return IEEE DEHL
    jp m32_fsmin                ; otherwise return IEEE underflow zero

.zero_legal
    ld e,d                      ; use 0
    ld hl,de
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL
