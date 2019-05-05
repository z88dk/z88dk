;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv - floating point divide
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
; m32_fsinv - floating point inversion (reciprocal)
;-------------------------------------------------------------------------
; 1/y can be calculated by:
; w[i+1] = w[i]*2 - w[i]*w[i]*y  where w[0] is approx 1/y
;
; The initial table lookup gets us 5 bits of precision.  The next iterations
; get 8, 14, and 26. At this point the number is rounded then multiplied
; by x using F_mul.
;
; Do the work in fixed point with 1 place to left of decimal point.
; 1.7 1.15 1.23 and 1.31, as we move through the calculations.
;
; The initial w[0] table is shifted once to fixed 1.7, and then shifted again
; to create the initial guess w[0] = 48/17 - 32/17 * y where 0.5 <= y <= 1.0
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN m32_fsmul, m32_fsmul_callee
EXTERN m32_fsmax_fastcall, m32_mulu_32_16x16

PUBLIC m32_fsdiv, m32_fsdiv_callee
PUBLIC m32_fsinv_fastcall


.m32_fsdiv
    call m32_fsinv_fastcall
    jp m32_fsmul


.m32_fsdiv_callee
    call m32_fsinv_fastcall
    jp m32_fsmul_callee


.m32_fsinv_fastcall
    ex de,hl                    ; DEHL -> HLDE

    add hl,hl                   ; sign into C
    ld a,h
    push af                     ; save exponent and sign in C

    or a                        ; divide by zero?
    jp Z,m32_fsmax_fastcall

    scf                         ; restore implicit bit
    rr l                        ; h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld h,l                      ; mantissa of y in hlde
    ld l,d
    ld d,e
    ld e,0                      ; a = 1mmmmmmm hlde = 1mmmmmmm mmmmmmmm mmmmmmmm --------

    push hl                     ; y msw on stack for w[3]
    push de                     ; y lsw on stack for w[3]
    push hl                     ; y msw on stack for w[2]
    push de                     ; y lsw on stack for w[2]
    push hl                     ; y msw on stack for w[1]

                                ; calculate w[0] - 5 bits
    ld a,h
    rra                         ; calculate w[0] table index for 32 Byte table
    rra
    and 01fh                    ; a = 000mmmmm

    ld hl,_invtable
    ld d,0
    ld e,a
    add hl,de

    ld d,(hl)                   ; w[0] fixed 1.7 with 5 bits accuracy in d, e
    ld e,d
                                ; calculate w[1] - 8 bits

    ld h,d                      ; w[0] with 5 bits accuracy in hl
    ld l,0

    add hl,hl                   ; w[0]*2 in hl

    ex (sp),hl                  ; w[0]*2 on stack, y msw in hl
    push hl                     ; y msw on stack

IF __CPU_Z180__
    mlt de                      ; d*e => de, w[0]^2 in de
    ex de,hl
ELSE

IF __CPU_Z80_ZXN__
    mul de                      ; d*e => de, w[0]^2 in de
    ex de,hl
ELSE

    EXTERN l_mulu_16_16x8
    ld l,d
    ld h,0
    call l_mulu_16_16x8         ; hl*e => hl, w[0]^2 in hl

ENDIF
ENDIF

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

IF __CPU_Z80__

    EXTERN l_mulu_64_32x32

    call l_mulu_64_32x32        ; dehl*dehl' => dehl, w[1]^2*y in dehld'e'h'l'
    exx
    ld a,d
    exx
    or a
    jr Z,fd0
    set 0,l
.fd0

ELSE
    EXTERN  m32_mulu_32h_32x32
    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[1]^2*y in dehl
ENDIF

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

IF __CPU_Z80__

    EXTERN l_mulu_64_32x32

    call l_mulu_64_32x32    ; dehl*dehl' => dehl, w[2]^2 in dehld'e'h'l'
    exx
    ld a,d
    exx
    or a
    jr Z,fd1
    set 0,l
.fd1

ELSE
    EXTERN  m32_mulu_32h_32x32
    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[2]^2 in dehl
ENDIF

    add hl,hl
    rl e
    rl d                        ; w[2]^2 in dehl

    exx
    pop hl                      ; y lsw in hl'
    pop de                      ; y msw in de'
    exx

IF __CPU_Z80__

    EXTERN l_mulu_64_32x32

    call l_mulu_64_32x32        ; dehl*dehl' => dehl, w[2]^2*y in dehld'e'h'l'
    exx
    ld a,d
    exx
    or a
    jr Z,fd2                    ; round number using digi norm's method
    set 0,l
.fd2

ELSE
    EXTERN  m32_mulu_32h_32x32
    call m32_mulu_32h_32x32     ; dehl*dehl' => dehl, w[2]^2*y in dehl
ENDIF

    add hl,hl
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

    ex de,hl                    ; 1/y mantissa in dehl

    add hl,hl                   ; shift 1/y mantissa dehl into position <<1
    rl e
    rl d

    ld a,l                      ; round number using digi norm's method
    or a
    jr Z,fd3
    set 0,h

.fd3
    pop af                      ; recover y exponent and sign in C
    rr b                        ; save sign in b
    sub a,07fh                  ; calculate new exponent for 1/y
    neg
    add a,07eh

    rl b                        ; recover sign from b

    rra                         ; pack 1/y result from a-deh into dehl
    ld l,h
    ld h,e
    ld e,d
    ld d,a

    ret C
    res 7,e                     ; clear exponent lsb if it is 0
    ret                         ; return DEHL

SECTION rodata_clib

._invtable
  DEFB 0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68
  DEFB 0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56
  DEFB 0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a
  DEFB 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40

