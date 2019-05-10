;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; square of two 24-bit numbers into a 32-bit product
;
; result is properly calculated into highest 32-bit result
; from a 48-bit calculation.
;
; Lower 8 bits intended to provide rounding information for
; IEEE floating point mantissa calculations.
;
; enter : abc = lde  = 24-bit multiplier  = x
;
; abc * abc
;
; = (a*a)*2^32 +
;   (2*a*b)*2^24 +
;   (b*b + 2*a*c)*2^16 +
;   (2*b*c)*2^8 +
;   (c*c)*2^0
;
; 6 8*8 multiplies in total
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl

SECTION code_clib
SECTION code_math

PUBLIC m32_sqr_32h_24x24


.m32_sqr_32h_24x24

    ld h,l                      ; aa:bc
    push hl                     ; aa on stack
    ld l,d                      ; ab:bc
    push hl                     ; ab on stack
    ld d,h                      ; ab:ac
    ld h,l                      ; bb:ac
    push hl                     ; bb on stack
    push de                     ; ac on stack
    ld d,e                      ; bc:ac
    push hl                     ; bc on stack
    ld d,e                      ; bc:cc

IF __CPU_Z180__
    mlt de                      ; c*c 2^0
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; c*c 2^0
ELSE
    EXTERN m32_z80_mulu_de
    call m32_z80_mulu_de        ; c*c 2^0
ENDIF
ENDIF

    ld c,d                      ; put 2^0 in bc
    ld b,0

IF __CPU_Z180__
    pop hl                      ; bc
    mlt hl                      ; b*c 2^8
ELSE
IF __CPU_Z80_ZXN__
    pop de                      ; bc
    mul de                      ; b*c 2^8
    ex de,hl
ELSE
    pop de                      ; bc
    call m32_z80_mulu_de        ; b*c 2^8
    ex de,hl
ENDIF
ENDIF

    xor a
    add hl,hl                   ; 2*b*c 2^8
    adc a,a
    add hl,bc
    adc a,0

    ld c,h                      ; put 2^8 in bc
    ld b,a

IF __CPU_Z180__
    pop hl                      ; ac
    pop de                      ; bb
    mlt hl                      ; a*c 2^16
    mlt de                      ; b*b 2^16
ELSE
IF __CPU_Z80_ZXN__
    pop de                      ; ac
    pop hl                      ; bb
    mul de                      ; a*c 2^16
    ex de,hl
    mul de                      ; b*b 2^16
ELSE
    pop de                      ; ac
    pop hl                      ; bb
    call m32_z80_mulu_de        ; a*c 2^16
    ex de,hl
    call m32_z80_mulu_de        ; b*b 2^16
ENDIF
ENDIF

    xor a
    add hl,hl                   ; 2*a*c 2^16
    adc a,a
    add hl,de
    adc a,a
    add hl,bc
    adc a,0

    ld c,h                      ; put 2^16 in bc
    ld b,a

    pop de                      ; ab

IF __CPU_Z180__
    mlt de                      ; a*b 2^24
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; a*b 2^24
ELSE
    call m32_z80_mulu_de        ; a*b 2^24
ENDIF
ENDIF

    ex de,hl                    ; l into e
    
    xor a
    add hl,hl                   ; 2*a*b 2^24
    adc a,a
    add hl,bc
    adc a,0

    ld c,e                      ; l into c
    ld b,l
    ld l,h
    ld h,a

    pop de                      ; aa

IF __CPU_Z180__
    mlt de                      ; a*a 2^32
ELSE
IF __CPU_Z80_ZXN__
    mul de                      ; a*a 2^32
ELSE
    call m32_z80_mulu_de        ; a*a 2^32
ENDIF
ENDIF

    add hl,de
    ld d,b
    ld e,c                      ; exit  : HLDE  = 32-bit product
    ret

