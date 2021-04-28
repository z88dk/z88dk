;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_l0_mulu_32h_24x24

PUBLIC m32_sqr_32h_24x24

;------------------------------------------------------------------------------
;
; feilipu, 2021 Apr
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
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl, af'

IF __IO_LUT_MODULE_AVAILABLE == 0

.m32_sqr_32h_24x24

    push hl                     ; preserve multiplicand
    push de

    push hl                     ; preserve multiplier
    push de

    ld a,e                      ; set up first multiplier from e

    jp m32_l0_mulu_32h_24x24    ; exit  : HLDE  = 32-bit product


ELSE ;  feilipu, 2020 February

.m32_sqr_32h_24x24

    push hl                     ; preserve multiplicand
    push de

;;; MLT HL (BC) ;;;;;;;;;;;;;;;;; b*c 2^8
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a
    add hl,hl                   ; 2*b*c 2^8
    adc a,a

    ld c,h                      ; put 2^8 in bc
    ld b,a

    pop hl                      ; ac
    pop de                      ; bb

    push bc
;;; MLT HL (BC) ;;;;;;;;;;;;;;;;; a*c 2^16
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; b*b 2^16
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    pop bc

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
    
    push bc
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; a*b 2^24
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    pop bc

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
    push bc
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; a*a 2^32
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de
    pop de                      ; exit  : HLDE  = 32-bit product
    ret

ENDIF
ENDIF
