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

PUBLIC asm_f16_mul_callee

PUBLIC asm_f24_mul_callee

PUBLIC asm_f24_mul_f24

; enter here for floating asm_f16_mul_callee, x+y, x on stack, y in hl, result in hl
.asm_f16_mul_callee
    call asm_f24_f16            ; expand to dehl
    exx                         ; y    d'  = eeeeeeee e = s-------
                                ;      hl' = 1mmmmmmm mmmmmmmm
    pop hl                      ; pop return address
    ex (sp),hl                  ; get second operand off of the stack,
                                ; return address on stack
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

IF __CPU_Z80__

    call mulu_32_16x16
    
ELSE

    EXTERN l_mulu_32_16x16

    call l_mulu_32_16x16        ; exit  : de * hl = dehl  = 32-bit product

ENDIF

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
    ex de,hl                    ; put 16 bit mantissa in place, de into hl
    ld a,d                      ; capture 8 rounding bits

    and 0c0h                    ; check for 2 lost bits rounding
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


IF __CPU_Z80__

; Made by Runer112
; Analysed by Zeda
; https://raw.githubusercontent.com/Zeda/z80float/master/common/mul16.z80
; Tested by jacobly
;
; DE*HL --> DEHL
;
; enter : de   = 16-bit multiplicand  = x
;         hl   = 16-bit multiplier = y
;
; exit  : dehl = 32-bit product
;
; uses  : af, bc, de, hl

.mulu_32_16x16

    ld a,d
    ld d,0
    ld b,h
    ld c,l

    add a,a
    jr C,bit14
    add a,a
    jr C,bit13
    add a,a
    jr C,bit12
    add a,a
    jr C,bit11
    add a,a
    jr C,bit10
    add a,a
    jr C,bit9
    add a,a
    jr C,bit8
    add a,a
    jr C,bit7

    ld a,e
    and %11111110
    add a,a
    jr C,bit6
    add a,a
    jr C,bit5
    add a,a
    jr C,bit4
    add a,a
    jr C,bit3
    add a,a
    jr C,bit2
    add a,a
    jr C,bit1
    add a,a
    jr C,bit0
    rr e
    ret C

    ld h,d
    ld l,e
    ret

.bit14
    add hl,hl
    adc a,a
    jr NC,bit13
    add hl,bc
    adc a,d

.bit13
    add hl,hl
    adc a,a
    jr NC,bit12
    add hl,bc
    adc a,d

.bit12
    add hl,hl
    adc a,a
    jr NC,bit11
    add hl,bc
    adc a,d

.bit11
    add hl,hl
    adc a,a
    jr NC,bit10
    add hl,bc
    adc a,d

.bit10
    add hl,hl
    adc a,a
    jr NC,bit9
    add hl,bc
    adc a,d

.bit9
    add hl,hl
    adc a,a
    jr NC,bit8
    add hl,bc
    adc a,d

.bit8
    add hl,hl
    adc a,a
    jr NC,bit7
    add hl,bc
    adc a,d

.bit7
    ld d,a
    ld a,e
    and %11111110
    add hl,hl
    adc a,a
    jr NC,bit6
    add hl,bc
    adc a,0

.bit6
    add hl,hl
    adc a,a
    jr NC,bit5
    add hl,bc
    adc a,0

.bit5
    add hl,hl
    adc a,a
    jr NC,bit4
    add hl,bc
    adc a,0

.bit4
    add hl,hl
    adc a,a
    jr NC,bit3
    add hl,bc
    adc a,0

.bit3
    add hl,hl
    adc a,a
    jr NC,bit2
    add hl,bc
    adc a,0

.bit2
    add hl,hl
    adc a,a
    jr NC,bit1
    add hl,bc
    adc a,0

.bit1
    add hl,hl
    adc a,a
    jr NC,bit0
    add hl,bc
    adc a,0

.bit0
    add hl,hl
    adc a,a
    jr C,funkyCarry
    rr e
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret

.funkyCarry
    inc d
    rr e
    ld e,a
    ret NC
    add hl,bc
    ret NC
    inc e
    ret

ENDIF

