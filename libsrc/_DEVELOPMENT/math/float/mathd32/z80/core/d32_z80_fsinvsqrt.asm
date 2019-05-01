;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;;
;-------------------------------------------------------------------------
; F_invsqrt - floating point inverse square root
;-------------------------------------------------------------------------
;
; Searching for 1/x^0.5 being the inverse square root of y.
;
; x = 1/y^0.5 where 1/y^0.5 can be calculated by:
;
; w[i+1] = w[i]*(1.5 - w[i]*w[i]*y/2) where w[0] is approx 1/y^0.5
;
;   float InvSqrt(float x)
;   {
;       float xhalf = 0.5f*x;
;       int i = *(int*)&x;
;       i = 0x5f375a86 - (i>>1);
;       x = *(float*)&i;
;       x = x*(1.5f-xhalf*x*x); // 1st Newton-Raphson Iteration
;       x = x*(1.5f-xhalf*x*x); // 2nd Newton-Raphson Iteration
;       return x;
;   }
;
; The initial magic number lookup gets us 8 bits of precision.
; The next iterations 14, and 26.
; At this point the number is rounded then multiplied by y using F_mul.
;
; Do the work in fixed point with 1 place to left of decimal point.
; 1.7 1.15 1.23 and 1.31, as we move through the calculations.
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN md32_fsmax_fastcall, md32_fsmul, md32_fsmul_callee, md32_fssub_callee
EXTERN m32_mulu_32_16x16, m32_mulu_32h_32x32

PUBLIC md32_fssqrt, md32_fssqrt_fastcall, md32_fsinvsqrt_fastcall


.md32_fssqrt
    call md32_fsinvsqrt_fastcall
    jp md32_fsmul


.md32_fssqrt_fastcall
    pop bc                      ; pop return address
    push de                     ; y msw on stack
    push hl                     ; y lsw on stack
    push bc                     ; put return back
    
    call md32_fsinvsqrt_fastcall
    jp md32_fsmul_callee


.md32_fsinvsqrt_fastcall        ; DEHL
    ld a,d
    or a                        ; divide by zero?
    jp Z,md32_fsmax_fastcall    
    and 080h                    ; negative number?
    jp NZ,md32_fsmax_fastcall

    push de                     ; y msw on stack for w[2]
    push hl                     ; y lsw on stack for w[2]
    push de                     ; y msw on stack for w[1]
    push hl                     ; y lsw on stack for w[1]

    ex de,hl                    ; original y in hlde
    ld b,h                      ; original y in bcde
    ld c,l
                                ; now calculate w[0]
    srl b                       
    rr c                        ; y>>1
    rr d
    rr e

    xor a                       ; w[0] = 0x5f375a86 - (y>>1)
    ld hl,05a86h
    sbc hl,de
    ex de,hl
    ld hl,05f37h
    sbc hl,bc                   ; (float) w[0] in hlde

    ld b,h                      ; (float) w[0] in hlde and bcde
    ld c,l

    pop af                      ; y lsw
    ex (sp),hl                  ; y msw, w[0] msw on stack
    push de                     ; w[0] lsw on stack
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack
    push bc
    push de

    ld h,b
    ld l,c
    ex de,hl                    ; (float) w[0] in dehl

    call md32_fsmul_callee      ; (float) w[0]*w[0]
    call md32_fsmul_callee      ; (float) w[0]*w[0]*y

    ld bc,04040h                ; (float) 3 = 0x40400000
    push bc
    ld bc,0
    push bc
    call md32_fssub_callee      ; (float) (3 - w[0]*w[0]*y)

    sla e                       ; unpack exponent (can only be positive)
    rl d
    dec d                       ; (float) (3 - w[0]*w[0]*y) / 2
    srl d
    rr e

    call md32_fsmul_callee      ; w[1] = (float) w[0]*(3 - w[0]*w[0]*y)/2

    ex de,hl                    ; (float) w[1] in hlde and bcde
    ld b,h
    ld c,l

    pop af                      ; y lsw
    ex (sp),hl                  ; y msw, w[1] msw on stack
    push de                     ; w[1] lsw on stack
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack
    push bc
    push de

    ld h,b
    ld l,c
    ex de,hl                    ; (float) w[1] in dehl

    call md32_fsmul_callee      ; (float) w[1]*w[1]
    call md32_fsmul_callee      ; (float) w[1]*w[1]*y

    ld bc,04040h                ; (float) 3 = 0x40400000
    push bc
    ld bc,0
    push bc
    call md32_fssub_callee      ; (float) (3 - w[1]*w[1]*y)

    sla e                       ; unpack exponent (can only be positive)
    rl d
    dec d                       ; (float) (3 - w[1]*w[1]*y) / 2
    srl d
    rr e

    call md32_fsmul_callee      ; w[2] = (float) w[1]*(3 - w[1]*w[1]*y)/2
    ret                         ; needs a return for the callee function

