;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul - z180 floating point multiply
;-------------------------------------------------------------------------
;
; since the z180 only has support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; abc * def
;
; = (ab*2^8+c) * (de*2^8+f)
; = ab*de*2^16 +
;   ab*f*2^8 + c*de*2^8 +
;   c*f
;
; = a*d*2^32 + a*e*2^24 + b*d*2^24 + b*e*2^16 + 
;   a*f*2^16 + b*f*2^8 +
;   c*d*2^16 + c*e*2^8 +
;   c*f
;
; = a*d*2^32 +
;   a*e*2^24 + b*d*2^24 +
;   b*e*2^16 + a*f*2^16 + c*d*2^16 +
;   b*f*2^8  + c*e*2^8  +
;   c*f
;
; assume worst overflow case:  abc=def=0xffffff
; assume worst underflow case: abc=def=0x800000
;
;   0xFF FF FF * 0xFF FF FF = 0x FF FF FE 00 00 01
;
;   0x80 00 00 * 0x80 00 00 = 0x 40 00 00 00 00 00
;
;   for underflow, maximum left shift is 1 place
;   so we should report 32 bits of accuracy (don't need all 48 bits)
;   = 24 bits significant + 1 bit shift + 7 bits rounding
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN m32_fszero_fastcall
EXTERN m32_mulu_32_16x16

PUBLIC m32_fsmul, m32_fsmul_callee


.m32_fsmul
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld hl,002h                  ; get second operand off of the stack
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld h,(hl)
    ld l,c                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    jr fmrejoin


.m32_fsmul_callee
    ex de,hl                    ; DEHL -> HLDE

    ld a,h                      ; put sign bit into A
    add hl,hl                   ; shift exponent into H
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

    exx                         ; first h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm

    pop bc                      ; pop return address
    pop de                      ; get second operand off of the stack
    pop hl                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    push bc                     ; return address on stack

.fmrejoin
    xor a,h                     ; xor exponents
    ex af,af                    ; save sign flag in a7' and f' reg

    add hl,hl                   ; shift exponent into h
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

                                ; second h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld a,h                      ; calculate the exponent
    or a                        ; second exponent zero then result is zero
    jp Z,m32_fszero_fastcall

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fmchkuf

    exx

    add a,h
    jp C,mulovl
    jr fmnouf

.fmchkuf
    exx

    add a,h                     ; add the exponents
    jp NC,fmzero

.fmnouf
    ld b,a
    ex af,af
    ld a,b
    ex af,af                    ; save sum of exponents a', and xor sign of exponents in f'

    ld a,b                      ; check sum of exponents for zero
    or a
    jp Z,m32_fszero_fastcall

                                ; a' = sum of exponents, f' = Sign of result
                                ; first  h  = eeeeeeee, lde  = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; second h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; sum of exponents in a', xor of exponents in sign f'
                                ;
                                ; multiplication of two 24-bit numbers into a 32-bit product
                                ;
                                ; = a*d*2^32 +
                                ;   a*e*2^24 + b*d*2^24 +
                                ;   b*e*2^16 + a*f*2^16 + c*d*2^16 +
                                ;   b*f*2^8  + c*e*2^8 +
                                ;   c*f
                                ;
                                ; 9 8*8 multiplies in total
                                ;
                                ; enter : abc = lde  = 24-bit multiplier   = x
                                ;         def = lde' = 24-bit multiplicand = y
                                ;
                                ; exit  : hlde  = 32-bit product
    ld h,l
    ld l,d
    push hl                     ; ab on stack
    push de                     ; bc on stack

    exx

    ld h,l
    ld l,d
    ld b,l
    ld c,d
    ex (sp),hl                  ; de on stack, bc in HL
    push bc                     ; de on stack (again)
    push hl                     ; bc on stack
    push de                     ; ef on stack

    exx

    ld b,h
    ld c,l                      ; ab in BC
    pop de                      ; ef in DE
    ld d,0                      ; 0f in DE
    call m32_mulu_32_16x16      ; ab*f => HLBC

    pop de                      ; bc in DE
    ex (sp),hl                  ; de in HL, ab*f msw on stack
    push bc                     ; ab*f lsw on stack
    
    ex de,hl                    ; de in DE
    ld c,l
    ld b,0                      ; 0c in BC
    call m32_mulu_32_16x16      ; de*c => HLBC
    
    xor a                       ; clear A
    
    ex (sp),hl                  ; de*c msw on stack, ab*f lsw in HL
    add hl,bc                   ; ab*f lsw + de*c lsw
    ex de,hl                    ; ab*f lsw + de*c lsw in DE
    
    pop hl                      ; de*c msw in HL
    pop bc                      ; ab*f msw in DE
    
    adc hl,bc                   ; ab*f msw + de*c msw

    adc a,a                     ; save ab*f msw + de*c msw carry in A

    pop bc                      ; de in BC
    ex (sp),hl                  ; ab*f msw + de*c msw + lsw C on stack, ab in HL
    ex de,hl                    ; ab*f lsw + de*c lsw in HL, ab in DE

    push af                     ; ab*f msw + de*c msw carry on stack
    push hl                     ; ab*f lsw + de*c lsw on stack

    call m32_mulu_32_16x16      ; ab*de => HLBC

    pop de                      ; ab*f lsw + de*c lsw in DE
    pop af                      ; ab*f msw + de*c msw carry in A
    ld e,a                      ; save ab*f msw + de*c msw carry in E

    ld a,c                      ; start adding the products with 8 bit offset
    add a,d                     ; ab*f lswh + de*c lswh + ab*de lswl
    ld d,a

    ld a,b
    pop bc                      ; ab*f msw + de*c msw + lsw C in BC
    adc a,c                     ; ab*f mswl + de*c mswl
    ld c,a

    ld a,l                      ; ab*de mswl
    adc a,b                     ; ab*f mswh + de*c mswh
    ld l,a

    ld a,h                      ; ab*de mswh
    adc a,e                     ; ab*f msw + de*c msw carry
    ld h,a

    ld e,d
    ld d,c                      ; exit  : HLDE  = 32-bit product

.fm1
    ex af,af                    ; retrieve sign and exponent from af'
    jp P,fm2
    scf

.fm2
    ld b,0                      ; put sign bit in B
    rr b

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,fm3a
    sla e
    rl d
    adc hl,hl
    jr fm3b

.fm3a
    inc a
    jr C,mulovl

.fm3b
    ex af,af
    ld a,e                      ; round result
    or a
    jr Z,fm3c
    set 0,d

.fm3c
    ex af,af

    ld e,h                      ; put 24 bit mantissa in place, HLD into EHL
    ld h,l
    ld l,d

    rra                         ; adjust the sign and exponent
    jr C,fm4
    res 7,e                     ; clear the implicit bit when doesn't match lsb of exp

.fm4
    or b
    ld d,a                      ; put sign and 7 msbs into place in D
    ret                         ; return DEHL

.fmzero
    ld d,0
    ld e,d
    ld h,d
    ld l,d
    ret                         ; done zero

.mulovl
    ex af,af                    ; get sign
    and a,07fh                  ; set INF
    ld d,a
    ld e,080h
    ld hl,0
    ret                         ; done overflow

