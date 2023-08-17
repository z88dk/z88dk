;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul - z80 floating point multiply
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; calculation for the z80 is done by replicating z180 mlt de functionality
; with a fast 16_8x8 multiply, with zero operand and zero bit elimination.
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
; = (a*d)*2^32 +
;   (a*e + b*d)*2^24 +
;   (b*e + a*f + c*d)*2^16 +
;   (b*f + c*e)*2^8 +
;   (c*f)*2^0
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

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_nzero, m32_fsconst_pzero
EXTERN m32_fsconst_ninf, m32_fsconst_pinf
EXTERN m32_mulu_32h_24x24

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
    ld e,(hl+)
    ld d,(hl+)
    ld c,(hl+)
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
    xor a,h                     ; xor sign flags
    ex af,af                    ; save sign flag in a[7]' and f' reg

    add hl,hl                   ; shift exponent into h
    scf                         ; set implicit bit
    rr l                        ; shift msb into mantissa

                                ; second h = eeeeeeee, lde = 1mmmmmmm mmmmmmmm mmmmmmmm

    ld a,h                      ; calculate the exponent
    or a                        ; second exponent zero then result is zero
    jr Z,mulzero

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fmchkuf

    exx

    add a,h
    jp C,mulovl
    jr fmnouf

.fmchkuf
    exx

    add a,h                     ; add the exponents
    jr NC,mulzero

.fmnouf
    ld b,a
    or a
    jr Z,mulzero                ; check sum of exponents for zero

    ex af,af
    ld a,b
    push af                     ; stack: sum of exponents a, and xor sign of exponents in f

                                ; first  h  = eeeeeeee, lde  = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; second h' = eeeeeeee, lde' = 1mmmmmmm mmmmmmmm mmmmmmmm
                                ; sum of exponents in a', xor of exponents in sign f'
                                ;
                                ; multiplication of two 24-bit numbers into a 32-bit product
    call m32_mulu_32h_24x24     ; exit  : HLDE  = 32-bit product

    pop bc                      ; retrieve sign and exponent from stack = b,c[7]

    bit 7,h                     ; need to shift result left if msb!=1
    jr NZ,fm2
    sla e
    rl d
    adc hl,hl
    jr fm3

.fm2
    inc b
    jr Z,mulovl

.fm3
    ld a,e
    ld e,h                      ; put 24 bit mantissa in place, HLD into EHL
    ld h,l
    ld l,d

    and 0c0h                    ; round using feilipu method
    jr Z,fm4
    set 0,l

.fm4
    sla e                       ; adjust mantissa for exponent
    sla c                       ; put sign into C
    ld d,b                      ; put exponent in D
    rr de                       ; put sign and 7 exp bits into place
                                ; put last exp bit into place
    ret                         ; return IEEE DEHL

.mulovl
    ex af,af                    ; get sign
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf         ; done overflow

.mulzero
    ex af,af                    ; get sign
    rla
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero        ; done underflow

