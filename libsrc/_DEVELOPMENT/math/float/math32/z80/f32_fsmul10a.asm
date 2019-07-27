;
;  feilipu, 2019 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul10a - z80, z180, z80n floating point multiply by 10
;-------------------------------------------------------------------------
; 
; Multiplication by 10. The lazy way.
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_fp_math32

PUBLIC m32_fsmul10a_fastcall
PUBLIC _m32_mul10a

EXTERN m32_fsmul_callee

   ; multiply DEHL by 10 and make positive
   ; 
   ; enter : DEHL= float x
   ;
   ; exit  : success
   ;
   ;            DEHL= abs(x) * 10
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            DEHL= +inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

._m32_mul10a
.m32_fsmul10a_fastcall
    ld bc,$4120                 ; (float)10 = 0x41200000
    push bc
    ld bc,0
    push bc
    res 7,d                     ; |x|
    call m32_fsmul_callee
    ret

