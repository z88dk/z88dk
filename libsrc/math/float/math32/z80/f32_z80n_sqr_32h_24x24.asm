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
; result is calculated for highest 32-bit result
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
;   (2*b*c)*2^8
;
;   NOT CALCULATED
;   (c*c)*2^0
;
; 5 8*8 multiplies in total
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl

IF __CPU_Z80N__

SECTION code_clib
SECTION code_fp_math32

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
    ld l,e                      ; bc:ac

    ex de,hl                    ; ac:bc
    mul de                      ; b*c 2^8
    ex de,hl

    xor a
    add hl,hl                   ; 2*b*c 2^8
    adc a,a

    ld c,h                      ; put 2^8 in bc
    ld b,a

    pop de                      ; ac
    pop hl                      ; bb
    mul de                      ; a*c 2^16
    ex de,hl
    mul de                      ; b*b 2^16

    xor a
    add hl,hl                   ; 2*a*c 2^16
    adc a,a
    add hl,de
    adc a,0
    add hl,bc
    adc a,0

    ld c,h                      ; put 2^16 in bc
    ld b,a

    pop de                      ; ab
    mul de                      ; a*b 2^24

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
    mul de                      ; a*a 2^32

    add hl,de
    ld d,b
    ld e,c                      ; exit  : HLDE  = 32-bit product
    ret

ENDIF
