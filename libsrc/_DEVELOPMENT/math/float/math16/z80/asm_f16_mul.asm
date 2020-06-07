;
;  feilipu, 2020 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul - z80 half floating point multiply 16-bit mantissa
;-------------------------------------------------------------------------
;
; since the z180, and z80n only have support for 8x8bit multiply,
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; ab * cd
;
; = (a*c)*2^16 +
;   (a*d + b*c)*2^8 +
;   (b*d)*2^0
;
; assume worst overflow case:  ab=cd=0xffff
; assume worst underflow case: ab=cd=0x8000
;
;   0xFFFF * 0xFFFF = 0x FF FE 00 01
;
;   0x8000 * 0x8000 = 0x 40 00 00 00
;
;   for underflow, maximum left shift is 1 place
;   so we should report 32 bits of accuracy
;   = 16 bits significant
;
; calculation for the z80 is done using unrolled shift+add.
; with zero operand and zero bit elimination for fast multiply option.
;
; unpacked format: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_zero
EXTERN asm_f24_inf

EXTERN l_mulu_32_16x16

PUBLIC asm_f16_mul_callee

PUBLIC asm_f24_mul_callee

PUBLIC asm_f24_mul_f24

; enter here for floating asm_f16_mul_callee, x+y, x on stack, y in hl, result in hl
.asm_f16_mul_callee
    call asm_f24_f16            ; expand to dehl
    exx                         ; y     d  = eeeeeeee e = s-------
                                ;       hl = 1mmmmmmm mmmmmmmm
    pop bc                      ; pop return address
    pop hl                      ; get second operand off of the stack
    push bc                     ; return address on stack
    call asm_f24_f16            ; expand to dehl
                                ; x     d  = eeeeeeee e = s-------
                                ;       hl = 1mmmmmmm mmmmmmmm
    call asm_f24_mul_f24
    jp asm_f16_f24


; enter here for floating asm_f24_mul_callee, x+y, x on stack, y in dehl, result in dehl
.asm_f24_mul_callee
    exx                         ; y     d  = eeeeeeee e = s-------
                                ;       hl = 1mmmmmmm mmmmmmmm
    pop bc                      ; pop return address
    pop hl                      ; x     d = eeeeeeee e = s------- hl = 1mmmmmmm mmmmmmmm
    pop de
    push bc                     ; return address on stack

.asm_f24_mul_f24
    ld a,e                      ; place op1.s in a[7]
    exx                         ; x     d' = eeeeeeee e' = s------- hl' = 1mmmmmmm mmmmmmmm

    xor a,e                     ; xor sign flags
    ex af,af                    ; save sign flag in a[7]' and f' reg

    ld a,d                      ; calculate the exponent
    or a                        ; second exponent zero then result is zero
    jr Z,mulzero

    sub a,07fh                  ; subtract out bias, so when exponents are added only one bias present
    jr C,fmchkuf

    exx

    add a,d
    jr C,mulovl
    jr fmnouf

.fmchkuf
    exx

    add a,d                     ; add the exponents
    jr NC,mulzero

.fmnouf
    ld b,a
    or a
    jr Z,mulzero                ; check sum of exponents for zero

    ex af,af
    ld a,b
    push af                     ; stack: sum of exponents a, and xor sign of exponents in f

                                ; first  d  = eeeeeeee e  = s------- hl  = 1mmmmmmm mmmmmmmm
                                ; second d' = eeeeeeee e' = s------- hl' = 1mmmmmmm mmmmmmmm
                                ; sum of exponents in a', xor of exponents in sign f'
    push hl
    exx
    pop de
                                ; multiplication of two 16-bit numbers into a 32-bit product
    call l_mulu_32_16x16        ; exit  : de * hl = dehl  = 32-bit product

    pop bc                      ; retrieve exponent and sign from stack = b,c[7]

    bit 7,d                     ; need to shift result left if msb!=1
    jr NZ,fm2
    add hl,hl
    rl e
    rl d
    jr fm3

.fm2
    inc b
    jr Z,mulovl

.fm3
    ex de,hl                     ; put 16 bit mantissa in place, de into hl
    ld a,d                       ; capture 8 rounding bits

    or a                         ; round
    jr Z,fm4
    set 0,l

.fm4
    ld d,b                      ; put exponent in d
    ld e,c                      ; put sign into e[7]
    ret                         ; return half float f24

.mulovl
    ex af,af                    ; get sign
    ld e,a
    jp asm_f24_inf              ; done overflow

.mulzero
    ex af,af                    ; get sign
    ld e,a
    jp asm_f24_zero             ; done underflow

