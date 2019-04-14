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
;-------------------------------------------------------------------------
; FIXME clocks worst case (close to average case)
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN md32_fsmul, m32_mulu_32_16x16

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
    ld a,l
    ld h,l                      ; mantissa of y in h(l=d)e
    ld l,d
                                ; a = 1mmmmmmm hle = hde = 1mmmmmmm mmmmmmmm mmmmmmmm

;   push hl                     ; for w[3] msw, y msw on stack
                                ; for w[3] cross product, y msw on stack

;   push de                     ; for w[3] cross product, y lsw on stack
    
    push hl                     ; for w[2], y msw on stack

    push hl                     ; for w[1], y msw on stack

                                ; calculate w[0] - 5 bits

    rra                         ; calculate w[0] table offset for 32 Byte table
    rra                         ; a = 001mmmmm
    and    0x1f                 ; a = 000mmmmm

    ld hl,_divtable
    ld b,0
    ld c,a
    add hl,bc

    ld b,(hl)
                                ; w[0] with 5 bits accuracy in b

                                ; calculate w[1] - 8 bits

    ld c,0
    ld d,b                      ; w[0] with 5 bits accuracy in de
    ld e,c
    ld h,b                      ; w[0] with 5 bits accuracy in hl
    ld l,c

    ex (sp),hl                  ; w[0] on stack, y msw in hl
    push hl                     ; y msw on stack

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2 in hlbc
    ex de,hl

    pop bc                      ; y msb in bc
    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[0]^2*y in hlbc
    ex de,hl                    ; w[1]^2*y in de   

    pop hl                      ; w[0] in hl
    add hl,hl

    sbc hl,de                   ; w[0]*2 - w[0]*w[0]*y
                                ; w[1] with 8 bits accuracy in hl
    
                                ; calculate w[2] - 14 bits

    ld b,h                      ; w[1] in bc
    ld c,l
    ld d,h                      ; w[1] in de
    ld e,l
    
    ex (sp),hl                  ; w[1] on stack, y msw in hl
    push hl                     ; y msw on stack

    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[1]^2 in hlbc
    ex de,hl

    pop bc
    call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[1]^2*y in hlbc
    ex de,hl

    pop hl                     ; w[1] in hl
    add hl,hl

    sbc hl,de                   ; w[1]*2 - w[1]^2*y

                                ; w[2] with 14 bits accuracy in hl
    ld de,0     ; FIXME
                                ; calculate w[3] - 26 bits - hlde

;   ld b,h                      ; w[2] in bc
;   ld c,l

;   pop af                  
    
;   add hl,hl                   ; w[2]+w[2] in hl
;   push hl                     ; w[2]+w[2] on stack (until we finish w[2]^2*y)

;   ld d,b                      ; w[2] in de
;   ld e,c

;   call m32_mulu_32_16x16      ; bc*de => hlbc, uses af, w[2]^2 in hlbc
;   ld c,b                      ; w[2]^2 lsw in bc (only use 24 bits)
;   ld b,l
            
                                ; start 32_24*24 multiply to get mantissa
                                ;
                                ; abc * def
                                ;
                                ; = ab*de*2^16 +
                                ;   ab*f*2^8 + c*de*2^8 +
                                ;   c*f (ignore this final term)
                                ;
                                ; y msw on stack 
                                ; y msw on stack 
                                ; y lsw on stack
                                ; w[2]*2 on stack
                                ;
                                ; w[2]^2 msw in hl, w[2]^2 lsw in bc

;   pop de                      ; w[2]*2 in de
;   pop af                      ; y lsw in af
;   ex de,hl                    ; w[2]^2 msw in de, w[2]*2 in hl
;   ex (sp),hl                  ; w[2]*2 on stack, y msw in hl
;   push de                     ; w[2]^2 msw on stack
;   push bc                     ; w[2]^2 lsw on stack
;   push hl                     ; y msw on stack
;   ld c,a                      ; y lsw in bc
;   ld b,0

;   call m32_mulu_32_16x16      ; 0c*de => hlbc, uses af, w[2]^2h*yl in hlbc

;   pop de                      ; y msw in de
;   ex (sp),hl                  ; w[2]^2h*yl msw on stack, w[2]^2 lsw in hl 
;   push bc                     ; w[2]^2h*yl lsw on stack

;   ld c,h                      ; w[2]^2 lsb in bc
;   ld b,0

;   call m32_mulu_32_16x16      ; 0c*de => hlbc, uses af, w[2]^2l*yh in hlbc

;   xor a                       ; clear a

;   ex (sp),hl                  ; w[2]^2l*yh msw on stack, w[2]^2h*yl lsw in hl
;   add hl,bc                   ; w[2]^2h*yl lsw + w[2]^2l*yh lsw
;   ex de,hl                    ; w[2]^2h*yl lsw + w[2]^2l*yh lsw in de

;   pop hl                      ; w[2]^2l*yh msw in hl
;   pop bc                      ; w[2]^2h*yl msw msw on stack in bc

;   adc hl,bc                   ; w[2]^2l*yh msw + w[2]^2h*yl msw + lsw C

;   adc a,a                     ; save w[2]^2l*yh msw + w[2]^2h*yl msw carry in a

;   pop bc                      ; w[2]^2 msw in bc
;   ex (sp),hl                  ; w[2]^2l*yh msw + w[2]^2h*yl msw + lsw C on stack, y msw in hl
;   ex de,hl                    ; w[2]^2h*yl lsw + w[2]^2l*yh lsw in hl, y msw in de

;   push af                     ; w[2]^2l*yh msw + w[2]^2h*yl msw carry on stack
;   push hl                     ; w[2]^2h*yl lsw + w[2]^2l*yh lsw on stack

;   call m32_mulu_32_16x16      ; ab*de => hlbc, uses af,w[2]^2h*yh in hlbc

;   pop de                      ; w[2]^2h*yl lsw + w[2]^2l*yh lsw in de
;   pop af                      ; w[2]^2l*yh msw + w[2]^2h*yl msw carry in a
;   ld e,a                      ; save w[2]^2l*yh msw + w[2]^2h*yl msw carry in e

;   ld a,c                      ; start adding the products with 8 bit offset
;   add a,d                     ; ab*f lswh + de*c lswh + ab*de lswl
;   ld d,a

;   ld a,b
;   pop bc                      ; ab*f msw + de*c msw + lsw C in BC
;   adc a,c                     ; ab*f mswl + de*c mswl
;   ld c,a

;   ld a,l                      ; ab*de mswl
;   adc a,b                     ; ab*f mswh + de*c mswh
;   ld l,a

;   ld a,h                      ; ab*de mswh
;   adc a,e                     ; ab*f msw + de*c msw carry
;   ld h,a

;   ld e,d
;   ld d,c                      ; hlde  = 32-bit product

;   ld b,h                      ; bcde = 32-bit product
;   ld c,l

;   ld hl,0                     ; w[2]*2 lsw
;   sbc hl,de                   ; w[2]*2 lsw - w[2]^2*y lsw
;   ex de, hl

;   pop hl                      ; w[2]*2 msw
;   sbc hl,bc                   ; w[3] with 26 bits accuracy in hlde

    ld de,0     ; FIXME remove this

    ex de,hl                    ; dehl  = 32-bit product

    add hl,hl                   ; shift mantissa dehl into position <<2
    rl e
    rl d
    add hl,hl
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

    ret C
    res 7,c                     ; clear exponent lsb if it is 0
    
    ret

SECTION rodata_clib

._divtable
  DEFB 0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68
  DEFB 0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56
  DEFB 0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a
  DEFB 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40

