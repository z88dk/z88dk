;
;  2019 April feilipu
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; F_div - floating point divide
;-------------------------------------------------------------------------
; r = x/y = x * 1/y
;
; We calculate division of two floating point number by refining an
; estimate of the reciprocal of y using newton iterations.  Each iteration
; gives us just less than twice previous precision in binary bits (2n-2).
;
; Division is then done by multiplying by the reciprocal of the divisor.
;
;-------------------------------------------------------------------------
; F_inv - floating point inversion (reciprocal)
;-------------------------------------------------------------------------
; 1/y can be calculated by:
; w[i+1] = w[i]*2 - w[i]*w[i]*y  where w[0] is approx 1/y
;
; The initial table lookup gets us 5 bits of precision.  The next iterations
; get 8, 14, and 26. At this point the number is rounded then multiplied
; by x using F_mul.
;
; Do the work in fixed point with 2 places to left of decimal point.
; 2.6 2.14 2.22 and 2.30, as we move through the calculations.
;
; The initial w[0] table is shifted once to fixed1.7, and then shifted again
; to create the initial guess w[0] = 48/17 - 32/17 * y where 0.5 <= y <= 1.0
;
;-------------------------------------------------------------------------
; FIXME clocks worst case (close to average case)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN md32_fsmul, m32_mulu_32_16x16, l0_z180_mulu_32_32x32

PUBLIC md32_fsdiv, md32_fsinv


.md32_fsdiv
    call md32_fsinv
    jp md32_fsmul


.fdbyzero
    ld  bc,0xff80               ; divide by zero -> INF
    ld  de,0x0000
    rr  b
    ret


.md32_fsinv
    ld  h,b
    ld  l,c

    add hl,hl                   ; sign in C
    ld a,h
    ex af,af                    ; save exponent and sign in C in af'

    ld a,h
    or a                        ; divide by zero?
    jr Z,fdbyzero

    scf                         ; restore implicit bit
    rr l
                                ; h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld h,l                      ; mantissa of y in hlde
    ld l,d
    ld d,e


    srl h                       ; shift mantissa right one place for 2.n fixed point
    rr l
    rr d
    rr e
    
    srl h                       ; shift mantissa one place to scale y 0.5<=y<=1.0
    rr l
    rr d
    rr e
                                ; a = 1mmmmmmm hlde = 001mmmmm mmmmmmmm mmmmmmmm mm------
    push hl                     ; y msw on stack for w[3]
    push de                     ; y lsw on stack for w[3]
    push hl                     ; y msw on stack for w[2]
    push de                     ; y lsw on stack for w[2]
    push hl                     ; y msw on stack for w[1]

                                ; calculate w[0] - 5 bits

                                ; calculate w[0] table offset for 32 Byte table
    ld a,h                      ; a = 001mmmmm
    and    0x1f                 ; a = 000mmmmm

    ld hl,_divtable
    ld b,0
    ld c,a
    add hl,bc

    ld b,(hl)                   ; w[0] fixed 2.6 with 5 bits accuracy in bc
    ld c,0    

                                ; calculate w[1] - 8 bits

    ld d,b                      ; w[0] with 5 bits accuracy in de
    ld e,c

    ld h,b                      ; w[0] with 5 bits accuracy in hl
    ld l,c

    add hl,hl                   ; w[0]*2

    ex (sp),hl                  ; w[0]*2 on stack, y msw in hl
    push hl                     ; y msw on stack

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2 in hlbc
    sla b
    adc hl,hl
    sla b
    adc hl,hl

    ex de,hl
    pop bc                      ; y msw in bc

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2*y in hlbc
    sla b
    adc hl,hl
    sla b
    adc hl,hl

    ex de,hl                    ; w[0]^2*y in de
    pop hl                      ; w[0]*2 in hl

    xor a
    sbc hl,de                   ; w[0] + w[0] - w[0]*w[0]*y
                                ; w[1] with 8 bits accuracy in hl
    
                                ; calculate w[2] in hlde - 14 bits

    ld d,h                      ; w[1] msw in de
    ld e,l
    
    add hl,hl                   ; w[1]*2

    pop af                      ; y lsw in af
    ex (sp),hl                  ; w[1]*2 msw on stack, y msw in hl
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack
    
    ld b,d                      ; w[1] msw in bc
    ld c,e

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[1]^2 in hlbc
    sla c
    rl b
    adc hl,hl
    sla c
    rl b
    adc hl,hl                    ; w[1]^2 in hlbc

    push bc
    exx
    pop de                      ; w[1]^2 lsw in de'
    pop bc                      ; y lsw in bc'
    exx
    pop bc                      ; y msw in bc
    ex de,hl                    ; w[1]^2 msw in de
      
    call l0_z180_mulu_32_32x32  ; bcbc'*dede' => dehl, w[1]^2*y in dehl
    add hl,hl
    rl e
    rl d
    add hl,hl
    rl e
    rl d                        ; w[1]^2*y in dehl

    ld b,d                      ; w[1]^2*y in bchl
    ld c,e

    xor a
    ld d,a                      ; w[1]*2 lsw = 0 in de
    ld e,a

    ex de,hl
    sbc hl,de                   ; w[1]*2 lsw - w[1]^2*y lsw

    ex de,hl

    pop hl                      ; w[1]*2 msw in hl
    sbc hl,bc                   ; w[1]*2 msw - w[1]^2*y msw
    
                                ; w[2] with 14 bits accuracy in hlde

                                ; calculate w[3] in hlde - 26 bits
            
    ld b,h                      ; w[2] msw in bc
    ld c,l

    pop af                      ; y lsw in af
    ex (sp),hl                  ; w[2] msw on stack, y msw in hl
    push de                     ; w[2] lsw on stack
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack

    push de                     ; w[2] lsw on stack
    push de                     ; w[2] lsw on stack
    exx
    pop de                      ; w[2] lsw in de'
    pop bc                      ; w[2] lsw in bc'
    exx

    ld d,b                      ; w[2] msw in de
    ld e,c

    call l0_z180_mulu_32_32x32  ; bcbc'*dede' => dehl, w[2]^2 in dehl
    add hl,hl
    rl e
    rl d
    add hl,hl
    rl e
    rl d                        ; w[2]^2 in dehl

    push hl
    exx
    pop de                      ; w[2]^2 lsw in de'
    pop bc                      ; y lsw in bc'
    exx
    pop bc                      ; y msw in bc

    call l0_z180_mulu_32_32x32  ; bcbc'*dede' => dehl, w[2]^2*y in dehl
    add hl,hl
    rl e
    rl d
    add hl,hl
    rl e
    rl d                        ; w[2]^2*y in dehl

    ld b,d                      ; w[2]^2*y in bchl
    ld c,e

    exx
    pop hl
    pop de
    add hl,hl
    ex de,hl
    adc hl,hl
    push hl
    push de
    exx                         ; w[2]*2 in dehl' and stack

    pop de
    ex de,hl
    sbc hl,de                   ; w[2]*2 lsw - w[2]^2*y lsw

    ex de,hl

    pop hl                      ; w[2]*2 msw in hl
    sbc hl,bc                   ; w[2]*2 msw - w[2]^2*y msw

                                ; w[3] with 26 bits accuracy in hlde
;   XXX debug
    push af
    push hl
    push de
    call asm_phexwd
    ex de, hl
    call asm_phexwd
    ld l,'_'
    call asm_pchar
    pop de
    pop hl
    pop af
;   XXX end debug

    ex de,hl                    ; dehl  = 32-bit product

    add hl,hl                   ; rescale y mantissa 1<=y<=2
    rl e
    rl d

    add hl,hl                   ; shift mantissa dehl into position <<1
    rl e
    rl d

    ld a,l                      ; round number using norm's method
    or a
    jr Z,fd4
    set 0,h

.fd4
    ex af,af                    ; recover y exponent and sign in C from af' 
    rr b                        ; save sign in b
    sub a,0x7f                  ; calculate new exponent for 1/y
    neg
    add a,0x7e

    rl b                        ; recover sign from b

    rra                         ; pack result
    ld b,a
    ld c,d
    ld d,e
    ld e,h

    jr C,fd5
    res 7,c                     ; clear exponent lsb if it is 0
    
.fd5
;   XXX debug
    push af
    push hl
    push de
    push bc
    ld h,b
    ld l,c
    call asm_phexwd
    ex de,hl
    call asm_phexwd
    ld l,' '
    call asm_pchar
    pop bc
    pop de
    pop hl
    pop af
;   XXX end debug
    ret

SECTION rodata_clib

._divtable
IF 0
  DEFB 0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68
  DEFB 0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56
  DEFB 0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a
  DEFB 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40
ENDIF

    DEFB 0x3C
    DEFB 0x3B
    DEFB 0x3B
    DEFB 0x39
    DEFB 0x39
    DEFB 0x37
    DEFB 0x37
    DEFB 0x35
    DEFB 0x35
    DEFB 0x33
    DEFB 0x33
    DEFB 0x31
    DEFB 0x31
    DEFB 0x30
    DEFB 0x2F
    DEFB 0x2E
    DEFB 0x2D
    DEFB 0x2C
    DEFB 0x2B
    DEFB 0x2B
    DEFB 0x29
    DEFB 0x28
    DEFB 0x27
    DEFB 0x26
    DEFB 0x25
    DEFB 0x25
    DEFB 0x23
    DEFB 0x23
    DEFB 0x21
    DEFB 0x21
    DEFB 0x20
    DEFB 0x3E
