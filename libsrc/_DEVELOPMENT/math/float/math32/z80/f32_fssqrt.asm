;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsinvsqrt - z80, z180, z80-zxn floating point inverse square root
;-------------------------------------------------------------------------
;
; Searching for 1/x^0.5 being the inverse square root of y.
;
; x = 1/y^0.5 where 1/y^0.5 can be calculated by:
;
; w[i+1] = w[i]*(1.5 - w[i]*w[i]*y/2) where w[0] is approx 1/y^0.5
;
;   float invsqrtf(float x)
;   {
;       float xhalf = 0.5f*x;
;       int i = *(int*)&x;
;       i = 0x5f375a86 - (i>>1);
;       x = *(float*)&i;
;       x = x*(1.5f-xhalf*x*x); // 1st Newton-Raphson Iteration
;       x = x*(1.5f-xhalf*x*x); // 2nd Newton-Raphson Iteration
;       x = x*(1.5f-xhalf*x*x); // 3rd N-R Iteration (to gild the lily)
;       return x;
;   }
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul, m32_fsmul_callee

EXTERN m32_fsmul32x32, m32_fsmul24x32, m32_fsadd32x32, m32_fsadd24x32
EXTERN m32_fsmin_fastcall

PUBLIC m32_fssqrt, m32_fssqrt_fastcall, m32_fsinvsqrt_fastcall
PUBLIC _m32_sqrtf, _m32_invsqrtf


.m32_fssqrt
    call m32_fsinvsqrt_fastcall
    jp m32_fsmul


._m32_sqrtf
.m32_fssqrt_fastcall
    push de                     ; y msw on stack
    push hl                     ; y lsw on stack
    
    call m32_fsinvsqrt_fastcall
    call m32_fsmul_callee
    ret


._m32_invsqrtf
.m32_fsinvsqrt_fastcall         ; DEHL
    ld a,d
    or a                        ; divide by zero?
    jp Z,m32_fsmin_fastcall    
    and 080h                    ; negative number?
    jp NZ,m32_fsmin_fastcall
    
    ld b,d                      ; retain original y sign & exponent
    set 7,d                     ; make y negative

    push de                     ; -y msw on stack for w[3] - remove for 2 iterations
    push hl                     ; -y lsw on stack for w[3] - remove for 2 iterations
    push de                     ; -y msw on stack for w[2] - remove for 1 iteration
    push hl                     ; -y lsw on stack for w[2] - remove for 1 iteration
    push de                     ; -y msw on stack for w[1]
    push hl                     ; -y lsw on stack for w[1]

    ex de,hl                    ; original y in hlde
    ld c,l                      ; original y in bcde
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

    add hl,hl                   ; get w[0] full exponent into h  
    rr c                        ; put sign in c

    scf
    rr l                        ; put implicit bit for mantissa in lde
    ld b,h                      ; unpack IEEE to expanded float 32-bit mantissa h lde0 -> b dehl
    ld d,l
    ld h,e   
    ld e,d
    ld l,0

;-------------------------------; Iteration 1

    exx
    pop hl                      ; -y lsw
    pop de                      ; -y msw

    exx
    push bc                     ; w[0]
    push de
    push hl

    exx
    ld bc,04040h                ; (float) 3 = 0x40400000
    push bc
    ld bc,0
    push bc
    push de                     ; -y msw
    push hl                     ; -y lsw

    exx
    push bc                     ; w[0]
    push de
    push hl

    call m32_fsmul32x32         ; (float) w[0]*w[0]
    call m32_fsmul24x32         ; (float) w[0]*w[0]*-y
    call m32_fsadd24x32         ; (float) (3 - w[0]*w[0]*y)

    dec b                       ; (float) (3 - w[0]*w[0]*y) / 2
    call m32_fsmul32x32         ; w[1] = (float) w[0]*(3 - w[0]*w[0]*y)/2

;----------- snip ----------    ; Iteration 2

    exx
    pop hl                      ; -y lsw
    pop de                      ; -y msw

    exx
    push bc                     ; w[1]
    push de
    push hl

    exx
    ld bc,04040h                ; (float) 3 = 0x40400000
    push bc
    ld bc,0
    push bc
    push de                     ; -y msw
    push hl                     ; -y lsw

    exx
    push bc                     ; w[1]
    push de
    push hl

    call m32_fsmul32x32         ; (float) w[1]*w[1]
    call m32_fsmul24x32         ; (float) w[1]*w[1]*-y
    call m32_fsadd24x32         ; (float) (3 - w[1]*w[1]*y)

    dec b                       ; (float) (3 - w[1]*w[1]*y) / 2
    call m32_fsmul32x32         ; w[2] = (float) w[1]*(3 - w[1]*w[1]*y)/2

;----------- snip ----------    ; Iteration 3

    exx
    pop hl                      ; -y lsw
    pop de                      ; -y msw

    exx
    push bc                     ; w[2]
    push de
    push hl

    exx
    ld bc,04040h                ; (float) 3 = 0x40400000
    push bc
    ld bc,0
    push bc
    push de                     ; -y msw
    push hl                     ; -y lsw

    exx
    push bc                     ; w[2]
    push de
    push hl

    call m32_fsmul32x32         ; (float) w[2]*w[2]
    call m32_fsmul24x32         ; (float) w[2]*w[2]*-y
    call m32_fsadd24x32         ; (float) (3 - w[2]*w[2]*y)

    dec b                       ; (float) (3 - w[2]*w[2]*y) / 2
    call m32_fsmul32x32         ; w[3] = (float) w[2]*(3 - w[2]*w[2]*y)/2

;----------- snip ----------

    ld a,l
    ld l,h                      ; align 32-bit mantissa to IEEE 24-bit mantissa
    ld h,e
    ld e,d

    or a                        ; round using feilipu method
    jr Z,fd0
    inc l
    jr NZ,fd0
    inc h
    jr NZ,fd0
    inc e
    jr NZ,fd0
    rr e
    rr h
    rr l
    inc b

.fd0
    sla e
    xor a                       ; set sign in C positive
    rr b
    rr e
    ld d,b
    ret                         ; return IEEE DEHL
