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
; Do the work in signed fixed point with 2 places to left of decimal point.
; 2.5 2.13 2.21 and 2.29, as we move through the calculations.
;
; The initial w[0] table is shifted once to fixed 2.6, and then shifted again
; to create the initial guess w[0] = 48/17 - 32/17 * y where 0.5 <= y <= 1.0
;
;-------------------------------------------------------------------------
; FIXME clocks worst case (close to average case)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN md32_fsmul, m32_mulu_32_16x16, l_z180_mulu_64_32x32


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
;   ex af,af                    ; save exponent and sign in C in af'
    push af                     ; XXX remove when af' recovered from mulu_64_32x32

    ld a,h
    or a                        ; divide by zero?
    jr Z,fdbyzero

    scf                         ; restore implicit bit
    rr l
                                ; h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld h,l                      ; mantissa of y in hlde
    ld l,d
    ld d,e
    ld e,0                      ; a = 1mmmmmmm hlde = 001mmmmm mmmmmmmm mmmmmmmm mm------

    push hl                     ; y msw on stack for w[3]
    push de                     ; y lsw on stack for w[3]
    push hl                     ; y msw on stack for w[2]
    push de                     ; y lsw on stack for w[2]
    push hl                     ; y msw on stack for w[1]

                                ; calculate w[0] - 5 bits
    ld a,h
	rra                         ; calculate w[0] table offset for 32 Byte table
	rra
    and    0x1f                 ; a = 000mmmmm

    ld hl,_divtable
    ld b,0
    ld c,a
    add hl,bc

    ld b,(hl)                   ; w[0]*2 signed fixed 2.5 with 5 bits accuracy in bc
    ld c,0    

                                ; calculate w[1] - 8 bits

    ld d,b                      ; w[0] with 5 bits accuracy in de
    ld e,c

    ld h,b                      ; w[0] with 5 bits accuracy in hl
    ld l,c

    add hl,hl                   ; w[0]*2 in hl

    ex (sp),hl                  ; w[0]*2 on stack, y msw in hl
    push hl                     ; y msw on stack

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2 in hlbc
    add hl,hl

    ex de,hl
    pop bc                      ; y msw in bc

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2*y in hlbc
    sla c
    rl b
    adc hl,hl

    ex de,hl                    ; w[0]^2*y in de
    pop hl                      ; w[0]*2 in hl

    xor a
    sbc hl,de                   ; w[0] + w[0] - w[0]*w[0]*y
                                ; w[1] with 8 bits accuracy in hl
    
                                ; calculate w[2] in hlde - 14 bits

    
    ld b,h                      ; w[1] msw in bc
    ld c,l

    add hl,hl                   ; w[1]*2 msw in hl

    pop af                      ; y lsw in af
    ex (sp),hl                  ; w[1]*2 msw on stack, y msw in hl
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack
    
    ld d,b                      ; w[1] msw in de
    ld e,c

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[1]^2 in hlbc
    sla c
    rl b
    adc hl,hl                    ; w[1]^2 in hlbc


    ld d,b
    ld e,c
    ex de,hl                    ; w[1]^2 in dehl

    exx
    pop hl                      ; y lsw in hl'
    pop de                      ; y msw in de'
    exx
      
    call l_z180_mulu_64_32x32  ; dehl*dehl' => dehl, w[1]^2*y in dehl
    add hl,hl
    rl e
    rl d                        ; w[1]^2*y in dehl


    ex de,hl                    ; w[1]^2*y in hlde

    ld b,h                      ; w[1]^2*y in bcde
    ld c,l

    xor a                       ; w[1]*2 lsw (zero) - w[1]^2*y lsw
    sub a,e
    ld e,a
    sbc a,a
    sub a,d
    ld d,a

    pop hl                      ; w[1]*2 msw in hl
    sbc hl,bc                   ; w[1]*2 msw - w[1]^2*y msw - C
    
                                ; w[2] with 14 bits accuracy in hlde

                                ; calculate w[3] in hlde - 26 bits

    ld b,h
    ld c,l
            
    add hl,hl                   ; w[2]*2 msw in hl

    pop af                      ; y lsw in af
    ex (sp),hl                  ; w[2]*2 msw on stack, y msw in hl
    push de                     ; w[2] lsw on stack
    push hl                     ; y msw on stack
    push af                     ; y lsw on stack

    ld h,b
    ld l,c
    ex de,hl                    ; w[2] msw in de, w[2] msw in de

    push de
    push hl
    exx
    pop hl
    pop de
    exx

    call l_z180_mulu_64_32x32  ; dehl*dehl' => dehl, w[2]^2 in dehl
    exx
    ld a,d
    exx
    add a,a
    adc hl,hl
    rl e
    rl d                        ; w[2]^2 in dehl


    exx
    pop hl                      ; y lsw in hl'
    pop de                      ; y msw in de'
    exx

    call l_z180_mulu_64_32x32  ; dehl*dehl' => dehl, w[2]^2*y in dehl
    exx
    ld a,d
    exx
    add a,a
    adc hl,hl
    rl e
    rl d                        ; w[2]^2*y in dehl


    ex de,hl                    ; w[2]^2*y in hlde

    ld b,h                      ; w[2]^2*y in bcde
    ld c,l

    pop hl
    add hl,hl                   ; w[2]*2 lsw
    ex de,hl

    xor a
    sbc hl,de                   ; w[2]*2 lsw - w[2]^2*y lsw
    ex de,hl

    pop hl                      ; w[2]*2 msw in hl
    sbc hl,bc                   ; w[2]*2 msw - w[2]^2*y msw - C

                                ; w[3] with 26 bits accuracy in hlde

    ex de,hl                    ; dehl  = 32-bit product

    add hl,hl                   ; shift mantissa dehl into position <<1
    rl e
    rl d

    ld a,l                      ; round number using norm's method
    or a
    jr Z,fd4
    set 0,h

.fd4
;   ex af,af                    ; recover y exponent and sign in C from af'
    pop af                      ; XXX remove
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
    ret

SECTION rodata_clib

._divtable
  DEFB 0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68
  DEFB 0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56
  DEFB 0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a
  DEFB 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40

