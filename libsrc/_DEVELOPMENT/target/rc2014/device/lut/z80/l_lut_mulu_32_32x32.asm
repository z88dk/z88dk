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

EXTERN l_lut_mulu_32_16x16

PUBLIC l_lut_mulu_32_32x32, l0_lut_mulu_32_32x32

l0_lut_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl'= 16-bit multiplier   = y
    ;         hl = 16-bit multiplicand = x
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, hl, bc', de', hl'

    push hl
    exx
    pop de
    jp l_lut_mulu_32_16x16

l_lut_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : dehl = 32-bit multiplicand
    ;         dehl'= 32-bit multiplicand
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    xor a
    or e
    or d

    exx
    or e
    or d
    jr Z,l0_lut_mulu_32_16x16   ;   demote if both are uint16_t

    push hl
    exx
    ld c,l
    ld b,h
    pop hl
    push de
    ex de,hl
    exx
    pop bc

l0_lut_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : dede' = 32-bit multiplier   = x
    ;         bcbc' = 32-bit multiplicand = y
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ; save material for the byte p3 = x3*y0 + x2*y1 + x1*y2 + x0*y3 + p2 carry
    push de                     ; 11 x3 x2
    exx                         ; 4
    push bc                     ; 11 y1 y0
    push de                     ; 11 x1 x0
    exx                         ; 4
    push bc                     ; 11 y3 y2

    ; save material for the byte p2 = x2*y0 + x0*y2 + x1*y1 + p1 carry
    ; start of 32_32x32

    ld h,e                      ; 4
    ld l,c                      ; 4
    push hl                     ; 11 x2 y2

    exx                         ; 4  now we're working in the low order bytes
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

    adc hl,bc                   ; HL = interim MSW p3 p2
    ex de,hl                    ; DEHL = end of 32_16x16

    push de                     ; stack interim p3 p2

    ; continue doing the p2 byte

    exx                         ; now we're working in the high order bytes
                                ; DEHL' = end of 32_16x16

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

    add hl,de                   ; 11
    pop de                      ; 10 destack interim p3 p2
    add hl,de                   ; 11

    ; start doing the p3 byte

    pop de                      ; 10 y3 y2
    ex (sp),hl                  ; 19 x1 x0, stack interim p3 p2

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; x1*y2
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E

;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; y3*x0
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L

    ld a,l                      ; 4  add low bytes of products
    add a,e                     ; 4
 
    pop hl                      ; 10 destack interim p3 p2
    add a,h                     ; 4
    ld h,a                      ; 4  return new p3, and p2

    pop de                      ; 10 y1 y0
    ex (sp),hl                  ; 19 x3 x2, stack interim p3 p2

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; x3*y0
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E

;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; y1*x2
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L

    ld a,l                      ; 4  add low bytes of products
    add a,e                     ; 4
 
    pop hl                      ; 10 destack interim p3 p2
    add a,h                     ; 4
    ld h,a                      ; 4 put final p3 back in H

    push hl                     ; 11

    exx                         ; 4  now we're working in the low order bytes, again
    pop de                      ; 10
    xor a                       ; 4  carry reset
    ret                         ;    exit  : DEHL = 32-bit product

