;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_invsqrt - z80, z180, z80n floating point inverse square root
;-------------------------------------------------------------------------
;
; Searching for 1/x^0.5 being the inverse square root of y.
;
; x = 1/y^0.5 where 1/y^0.5 can be calculated by:
;
; w[i+1] = w[i]*(1.5 - w[i]*w[i]*y/2) where w[0] is approx 1/y^0.5
;
;   half_t invsqrtf(half_t x)
;   {
;       half_t xhalf = 0.5*x;
;       int i = *(int*)&x;
;       i = 0xBE6EB5 - (i>>1);
;       x = *(float*)&i;
;       x = x*(3*(f-xhalf*x*x)/2; // 1st Newton-Raphson Iteration
;       x = x*(3*(f-xhalf*x*x)/2; // 2nd Newton-Raphson Iteration
;       return x;
;   }
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f32_f24

EXTERN asm_f24_f32
EXTERN asm_f16_f24

EXTERN asm_f24_zero
EXTERN asm_f24_inf
EXTERN asm_f24_nan

EXTERN asm_f24_mul_callee
EXTERN asm_f24_add_callee

PUBLIC asm_f16_sqrt
PUBLIC asm_f16_invsqrt

PUBLIC asm_f24_sqrt
PUBLIC asm_f24_invsqrt


.asm_f16_sqrt
    call asm_f24_f16
    call asm_f24_sqrt
    jp asm_f16_f24


.asm_f16_invsqrt
    call asm_f24_f16
    call asm_f24_invsqrt
    jp asm_f16_f24


.asm_f24_sqrt
    inc d
    dec d
    jp Z,asm_f24_zero           ; zero exponent? zero result

    pop bc                      ; ret
    push de                     ; y msw on stack
    push hl                     ; y lsw on stack
    push bc                     ; ret
    call asm_f24_invsqrt
    jp asm_f24_mul_callee


.asm_f24_invsqrt
    inc d
    dec d
    jp Z,asm_f24_inf            ; zero exponent? infinite result

    bit 7,e
    jp NZ,asm_f24_nan           ; negative number?

    set 7,e                     ; make y negative

    push de                     ; -y msw on stack for w[2] - remove for 1 iteration
    push hl                     ; -y lsw on stack for w[2] - remove for 1 iteration
    push de                     ; -y msw on stack for w[1]
    push hl                     ; -y lsw on stack for w[1]

    ld b,h                      ; original y to debc
    ld c,l                      ; now calculate w[0]

    sla b                       ; remove mantissa leading bit

    srl d                       ; y>>1
    rr b

    xor a                       ; clear carry
    ld e,a                      ; clear sign in e[7]

    ld hl,06EB5h                ; w[0] = 0xBE exponent 0x6EB5 mantissa - (y)
    sbc hl,bc                   ; subtract mantissa

    ld a,0BEh
    sbc a,d                     ; subtract exponent plus carry
    ld d,a

    scf                         ; restore mantissa leading bit
    rr hl
                                ; (f24) w[0] in dehl

;----------- snip ----------    ; Iteration 1

    exx
    pop hl                      ; -y lsw
    pop de                      ; -y msw

    exx
    push de                     ; w[0]
    push hl

    exx
    ld bc,08000h                ; (float) 3 = 0x 80 00
    push bc
    ld bc,0C000h                ; 0x C0 00
    push bc
    push de                     ; -y msw
    push hl                     ; -y lsw

    exx
    push de                     ; w[0]
    push hl

    call asm_f24_mul_callee     ; (float) w[0]*w[0]
    call asm_f24_mul_callee     ; (float) w[0]*w[0]*-y
    call asm_f24_add_callee     ; (float) (3 - w[0]*w[0]*y)

    dec d                       ; (float) (3 - w[0]*w[0]*y) / 2
    call asm_f24_mul_callee     ; w[1] = (float) w[0]*(3 - w[0]*w[0]*y)/2

;----------- snip ----------    ; Iteration 2

    exx
    pop hl                      ; -y lsw
    pop de                      ; -y msw

    exx
    push de                     ; w[1]
    push hl

    exx
    ld bc,08000h                ; (float) 3 = 0x 80 00
    push bc
    ld bc,0C000h                ; 0x C0 00
    push bc
    push de                     ; -y msw
    push hl                     ; -y lsw

    exx
    push de                     ; w[1]
    push hl

    call asm_f24_mul_callee     ; (float) w[1]*w[1]
    call asm_f24_mul_callee     ; (float) w[1]*w[1]*-y
    call asm_f24_add_callee     ; (float) (3 - w[1]*w[1]*y)

    dec d                       ; (float) (3 - w[1]*w[1]*y) / 2
    call asm_f24_mul_callee     ; w[2] = (float) w[1]*(3 - w[1]*w[1]*y)/2

;---------------------------

    ret                         ; return _f24
