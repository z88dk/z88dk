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
    jp NC,m32_fszero_fastcall

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

    ld h,l                      ; ab:bc
    ld l,d
    ld a,h                      ; a in a             
    
    exx
    ld h,a
    push hl                     ; ad on stack
    ld h,l                      ; de:ef
    ld l,d
    push hl                     ; de on stack
    push de                     ; ef on stack
    ld a,h                      ; d in a

    exx
    ld d,a                      ; dc in de
    ld b,h
    ld c,l
    ex (sp),hl                  ; ab on stack, ef in HL
    push de                     ; dc on stack
    push bc                     ; ab on stack (again)
    push hl                     ; ef on stack

    exx
    push de                     ; ef on stack
    ld a,e                      ; f in a
    
    exx
    ld d,l
    push de                     ; bc on stack
    ld d,a                      ; fc in de

IF __CPU_Z180__
    mlt de                      ; c*f 2^0
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; c*f 2^0
ELSE
    EXTERN m32_z80_mulu_de
    call m32_z80_mulu_de        ; c*f 2^0
ENDIF
ENDIF

    ld c,d                      ; put 2^0 in bc
    ld b,0

    pop de                      ; bc
    pop hl                      ; ef
    ld a,h
    ld h,e
    ld e,a

IF __CPU_Z180__
    mlt hl                      ; b*e 2^8
    mlt de                      ; c*f 2^8
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; b*e 2^8
    ex de,hl
    mul de                      ; c*f 2^8
ELSE
    call m32_z80_mulu_de        ; b*e 2^8
    ex de,hl
    call m32_z80_mulu_de        ; c*f 2^8
ENDIF
ENDIF

    xor a
    add hl,bc
    adc a,a
    add hl,de
    adc a,0

    ld c,h                      ; put 2^8 in bc
    ld b,a

    pop de                      ; ef
    pop hl                      ; ab
    ld a,d
    ld d,h
    ld h,a

IF __CPU_Z180__
    mlt hl                      ; a*f 2^16
    mlt de                      ; e*b 2^16
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; a*f 2^16
    ex de,hl
    mul de                      ; e*b 2^16
ELSE
    call m32_z80_mulu_de        ; a*f 2^16
    ex de,hl
    call m32_z80_mulu_de        ; e*b 2^16
ENDIF
ENDIF

    xor a
    add hl,bc
    adc a,a
    add hl,de
    adc a,0

    pop de                      ; dc

IF __CPU_Z180__
    mlt de                      ; d*c 2^16
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; d*c 2^16
ELSE
    call m32_z80_mulu_de        ; d*c 2^16
ENDIF
ENDIF

    add hl,de
    adc a,0

    ld c,h                      ; put 2^16 in bca
    ld b,a
    ld a,l

    pop de                      ; ab
    pop hl                      ; de

    push af                     ; l on stack

    ld a,d
    ld d,h
    ld h,a

IF __CPU_Z180__
    mlt hl                      ; d*b 2^24
    mlt de                      ; a*e 2^24
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; d*b 2^24
    ex de,hl
    mul de                      ; a*e 2^24
ELSE
    call m32_z80_mulu_de        ; d*b 2^24
    ex de,hl
    call m32_z80_mulu_de        ; a*e 2^24
ENDIF
ENDIF

    xor a
    add hl,bc
    adc a,a
    add hl,de
    adc a,0

    pop bc                     ; l in b
    ld c,b
    ld b,l
    ld l,h
    ld h,a

    pop de                      ; ad

IF __CPU_Z180__
    mlt de                      ; a*d 2^32
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; a*d 2^32
ELSE
    call m32_z80_mulu_de        ; a*d 2^32
ENDIF
ENDIF

    add hl,de

    ld d,b
    ld e,c                      ; exit  : HLDE  = 32-bit product

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
    ld a,e                      ; round using digi norm's method
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

.mulovl
    ex af,af                    ; get sign
    and a,07fh                  ; set INF
    ld d,a
    ld e,080h
    ld hl,0
    ret                         ; done overflow

