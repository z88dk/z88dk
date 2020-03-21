;
;  feilipu, 2020 March
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; Using RC2014 LUT Module
;
;------------------------------------------------------------------------------

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_lut_mulu_64_32x32, l0_lut_mulu_64_32x32

l_lut_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : dehl = 32-bit multiplicand
    ;         dehl'= 32-bit multiplicand
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    ld c,l
    ld b,h
    push de
    exx
    pop bc
    push hl
    exx
    pop de

l0_lut_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : de'de = 32-bit multiplier    = x
    ;         bc'bc = 32-bit multiplicand  = y
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    ; save material for the byte p7 p6 = x3*y3 + p5 carry
    exx                         ; 4 '
    ld h,d                      ; 4 '          
    ld l,b                      ; 4 '
    push hl                     ; 10'x3 y3

    ; save material for the byte p5 = x3*y2 + x2*y3 + p4 carry
    ld l,c                      ; 4 '
    push hl                     ; 11'x3 y2
    ld h,b                      ; 4 '
    ld l,e                      ; 4 '
    push hl                     ; 11'y3 x2

    ; save material for the byte p4 = x3*y1 + x2*y2 + x1*y3 + p3 carry
    ld h,e                      ; 4 '
    ld l,c                      ; 4 '
    push hl                     ; 11'x2 y2
    ld h,d                      ; 4 '
    ld l,b                      ; 4 '
    push hl                     ; 11'x3 y3
    exx                         ; 4
    ld l,b                      ; 4
    ld h,d                      ; 4
    push hl                     ; 11 x1 y1

    ; save material for the byte p3 = x3*y0 + x2*y1 + x1*y2 + x0*y3 + p2 carry
    push bc                     ; 11 y1 y0
    exx                         ; 4 '
    push de                     ; 11'x3 x2
    push bc                     ; 11'y3 y2
    exx                         ; 4
    push de                     ; 11 x1 x0

    ; save material for the byte p2 = x2*y0 + x0*y2 + x1*y1 + p1 carry
    ; start of 32_32x32
    exx                         ; 4 '
    ld h,e                      ; 4 '
    ld l,c                      ; 4 '
    push hl                     ; 11'x2 y2

    exx                         ; 4
    ld h,e                      ; 4
    ld l,c                      ; 4
    push hl                     ; 11 x0 y0

    ; start of 32_16x16          p1 = x1*y0 + x0*y1 + p0 carry
    ;                            p0 = x0*y0

    ld h,d                      ; 4
    ld l,b                      ; 4
    push hl                     ; 11 x1 y1

    ld h,e                      ; 4
    ld l,c                      ; 4
    push hl                     ; 11 x0 y0

    ld h,b                      ; 4  y1
    ld l,c                      ; 4  y0

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; y1*x0
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; x1*y0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    xor a                       ; 4  zero A
    add hl,de                   ; 11 add cross products
    adc a,a                     ; 4  capture carry

    pop de                      ; 10 restore y0*x0

;;; MLT DE (xBC) ;;;;;;;;;;;;;;;; y0*x0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from A
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    ld b,a                      ; 4  carry from cross products

    ld a,d                      ; 4
    add a,l                     ; 4
    ld d,a                      ; 4  de = final LSW

    ld l,h                      ; 4  LSB of MSW from cross products
    ld h,b                      ; 4  carry from cross products

    ex (sp),hl                  ; 19 restore y1*x1, stack interim p3 p2

;;; MLT HL (xBC) ;;;;;;;;;;;;;;;; x1*y1
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
    
    pop bc                      ; 10 destack interim p3 p2

    adc hl,bc                   ; 15 HL = interim MSW p3 p2
    ex de,hl                    ; 4  DEHL = end of 32_16x16

    push de                     ; 11 stack interim p3 p2

    ; continue doing the p2 byte

    exx                         ; 4  now we're working in the high order bytes
                                ;    DEHL' = end of 32_16x16
    pop hl                      ; 10 destack interim p3 p2

    pop de                      ; 10 x0 y0
    ex (sp),hl                  ; 19 x2 y2, stack interim p3 p2

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; x2*y0
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; x0*y2
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    xor a                       ; 4
    add hl,de                   ; 11
    adc a,a                     ; 4  capture carry p4
    pop de                      ; 10 destack interim p3 p2
    add hl,de                   ; 11
    adc a,0                     ; 4  capture carry p4
    
    push hl                     ; 11
    
    exx                         ; 4 '
    pop de                      ; 10'save p2 in E'
    
    exx                         ; 4

    ld l,h                      ; 4  promote HL p4 p3
    ld h,a                      ; 4

    ; start doing the p3 byte

    pop de                      ; 10 y3 y2
    ex (sp),hl                  ; 19 x1 x0, stack interim p4 p3

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; x1*y2
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; y3*x0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
    
    xor a                       ; 4  zero A
    add hl,de                   ; 11 p4 p3
    adc a,a                     ; 4  p5
    pop de                      ; 10 destack interim p4 p3
    add hl,de                   ; 11 p4 p3
    adc a,0                     ; 4  p5

    pop de                      ; 10 x3 x2
    ex (sp),hl                  ; 19 y1 y0, stack interim p4 p3

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; y1*x2
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; x3*y0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    add hl,de                   ; 11 p4 p3
    adc a,0                     ; 4  p5
    
    pop de                      ; 10 destack interim p4 p3
    add hl,de                   ; 11 p4 p3
    adc a,0                     ; 4  p5

    push hl                     ; 11 leave final p3 in L 

    exx                         ; 4 '
    pop bc                      ; 10'
    ld d,c                      ; 4 'put final p3 in D

    exx                         ; 4  low 32bits in DEHL

    ld l,h                      ; 4  prepare HL for next cycle
    ld h,a                      ; 4  promote HL p5 p4

    ; start doing the p4 byte

    pop de                      ; 10 x1 y1
    ex (sp),hl                  ; 19 x3 y3, stack interim p5 p4

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; x3*y1
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; x1*y3
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
    
    xor a                       ; 4  zero A
    add hl,de                   ; 11 p5 p4
    adc a,a                     ; 4  p6

    pop de                      ; 10 destack interim p5 p4
    add hl,de                   ; 11 p5 p4
    adc a,0                     ; 7  p6

    pop de                      ; 10 x2 y2

;;; MLT DE (xBC) ;;;;;;;;;;;;;;;; x2*y2
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    add hl,de                   ; 11 p5 p4
    adc a,0                     ; 4  p6

    ld e,l                      ; 4  final p4 byte in E
    ld l,h                      ; 4  prepare HL for next cycle
    ld h,a                      ; 4  promote HL p6 p5

    ; start doing the p5 byte

    ex (sp),hl                  ; 19 y3 x2, stack interim p6 p5

;;; MLT HL (xBC) ;;;;;;;;;;;;;;;; y3*x2
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

    xor a                       ; 4  zero A
    pop bc                      ; 10 destack interim p6 p5
    add hl,bc                   ; 11 p6 p5
    adc a,a                     ; 4  p7

    ex (sp),hl                  ; 19 x3 y2, stack interim p6 p5

;;; MLT HL (xBC) ;;;;;;;;;;;;;;;; x3*y2
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

    pop bc                      ; 10 destack interim p6 p5
    add hl,bc                   ; 4  p6 p5
    adc a,0                     ; 4  p7

    ld d,l                      ; 4  final p5 byte in D
    ld l,h                      ; 4  prepare HL for next cycle
    ld h,a                      ; 4  promote HL p7 p6

    ; start doing the p6 p7 bytes

    ex (sp),hl                  ; 19 x3 y3, stack interim p7 p6

;;; MLT HL (xBC) ;;;;;;;;;;;;;;;; x3*y3
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

    pop bc                      ; 10 destack interim p7 p6
    add hl,bc                   ; 4  p7 p6
    ex de,hl                    ; 4  p7 p6 <-> p5 p4

    ret                         ;    exit  : DEHL DEHL' = 64-bit product
