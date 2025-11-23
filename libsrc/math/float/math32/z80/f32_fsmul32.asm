;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul32x32 - z80 floating point multiply 32-bit mantissa
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
;
; LHS unpacked number on stack the RHS unpacked in bcdehl
; unpacked format: mantissa= dehl, exponent in b, sign in c[7]
;
;-------------------------------------------------------------------------
; m32_fsmul24x32 - z80 floating point multiply 32-bit mantissa
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
;
; one packed IEEE number on stack, the other unpacked number in bcdehl
; unpacked format: mantissa= dehl, exponent in b, sign in c[7]
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_mulu_32h_24x24, m32_mulu_32h_32x32

PUBLIC m32_fsmul24x32, m32_fsmul32x32


.m32_fsmul32x32
    ld a,c                      ; put sign bit into A
    ex af,af

    exx                         ; first b' = eeeeeeee c' = s-------
                                ;   de'hl' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm

    pop af                      ; pop return address
    pop hl                      ; get second operand off of the stack
    pop de                      ; second b' = eeeeeeee c' = s-------
    pop bc                      ;    de'hl' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
    push af                     ; return address on stack
    
    ex af,af
    xor a,c                     ; xor sign flags
    ex af,af                    ; save sign flag in a7' and f' reg
    jr fmrejoin


.m32_fsmul24x32
    ld a,c                      ; put sign bit into A

    exx                         ; first b' = eeeeeeee c' = s-------
                                ;   de'hl' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm

    pop bc                      ; pop return address
    pop de                      ; get second operand off of the stack
    pop hl                      ; hlde = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    push bc                     ; return address on stack
    
    xor a,h                     ; xor sign flags
    ex af,af                    ; save sign flag in a[7]' and f' reg

    add hl,hl                   ; shift exponent into h
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa
    
    ld b,h                      ; put exponent into B = eeeeeeee
    ld h,e                      ; put mantissa from LDE0 into DEHL
    ld e,d
    ld d,l                      ; second b = eeeeeeee c = s-------
    ld l,0                      ;    dehl = 1mmmmmmm mmmmmmmm mmmmmmmm 00000000

.fmrejoin
    ld a,b                      ; calculate the exponent
    or a                        ; second exponent zero then result is zero
    jp Z,mulzero

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fmchkuf

    exx

    add a,b
    jp C,mulovl
    jr fmnouf

.fmchkuf
    exx

    add a,b                     ; add the exponents
    jp NC,mulzero

.fmnouf
    ld b,a
    or a
    jp Z,mulzero                ; check sum of exponents for zero

    ex af,af
    ld a,b
    push af                     ; stack: sum of exponents a, and xor sign of exponents in f

                                ; first  dehl  = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
                                ; second dehl' = 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
                                ; sum of exponents, xor of exponents sign on stack = b,c[7]
                                ;
                                ; multiplication of two 32-bit numbers into a 32-bit product
    call m32_mulu_32h_32x32     ; exit  : dehl  = 32-bit product

    pop bc                      ; retrieve sign and exponent from stack = b,c[7]

    bit 7,d                     ; need to shift result left if msb!=1
    jr NZ,fm0
    add hl,hl    
    rl de
    ret                         ; return BC DEHL

.fm0
    inc b
    ret NZ                      ; return BC DEHL
                                ; othewise overflow
.mulovl
    ex af,af                    ; get sign
    ld c,a
    ld b,0ffh                   ; set Infinity
    ld d,0
    ld e,d
    ld h,d
    ld h,d
    ret                         ; done overflow

.mulzero
    ex af,af                    ; get sign
    and a,080h
    ld c,a
    ld b,0                      ; set ZERO
    ld d,b
    ld e,b
    ld h,b
    ld l,b
    ret                         ; done zero


