;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; multiplication of two 24-bit numbers into a 32-bit product
;
; result is properly calculated into highest 32-bit result
; from a 48-bit calculation.
;
; Lower 8 bits intended to provide rounding information for
; IEEE floating point mantissa calculations.
;
; enter : abc = lde  = 24-bit multiplier   = x
;         def = lde' = 24-bit multiplicand = y
;
; abc * def
; = (a*d)*2^32 +
;   (a*e + b*d)*2^24 +
;   (b*e + a*f + c*d)*2^16 +
;   (b*f + c*e)*2^8 +
;   (c*f)*2^0
;
; 9 8*8 multiplies in total
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl, bc', de', hl'

SECTION code_clib
SECTION code_math

PUBLIC m32_mulu_32h_24x24


.m32_mulu_32h_24x24

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
    ret

