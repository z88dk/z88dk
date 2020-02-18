;
;  feilipu, 2019 April
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

EXTERN m32_z80_mulu_de

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
; NOTE THIS IS NOT A TRUE MULTIPLY.
; Carry in from low bytes is not calculated.
; Rounding is done at 2^16.
;
; enter : dehl  = 32-bit multiplier   = x
;         dehl' = 32-bit multiplicand = y
;
; exit  : dehl = 32-bit product
;         carry reset
;
; uses  : af, bc, de, hl, af', bc', de', hl'


.m32_mulu_32h_32x32

    ld c,l
    ld b,h
    push de
    exx
    pop bc
    push hl
    exx
    pop de

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : de'de = 32-bit multiplier    = x
    ;         bc'bc = 32-bit multiplicand  = y
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    ; save material for the byte p7 p6 = x3*y3 + p5 carry
    exx                         ;'
    ld h,d
    ld l,b
    push hl                     ;'x3 y3

    ; save material for the byte p5 = x3*y2 + x2*y3 + p4 carry
    ld l,c
    push hl                     ;'x3 y2
    ld h,b
    ld l,e
    push hl                     ;'y3 x2

    ; save material for the byte p4 = x3*y1 + x2*y2 + x1*y3 + p3 carry
    ld h,e
    ld l,c
    push hl                     ;'x2 y2
    ld h,d
    ld l,b
    push hl                     ;'x3 y3
    exx                         ;
    ld l,b
    ld h,d
    push hl                     ; x1 y1

    ; save material for the byte p3 = x3*y0 + x2*y1 + x1*y2 + x0*y3
    push bc                     ; y1 y0
    exx                         ;'
    push de                     ;'x3 x2
    push bc                     ;'y3 y2
    exx                         ;
;   push de                     ; x1 x0

IF __IO_LUT_MODULE_AVAILABLE == 0

    ; start doing the p3 byte

    pop hl                      ; y3 y2
    ld a,h
    ld h,d
    ld d,a
    call m32_z80_mulu_de        ; y3*x0
    ex de,hl
    call m32_z80_mulu_de        ; x1*y2

    xor a                       ; zero A
    add hl,de                   ; p4 p3
    adc a,a                     ; p5
    ld b,h
    ld c,l
    ex af,af

    pop hl                      ; x3 x2
    pop de                      ; y1 y0
    ld a,h
    ld h,d
    ld d,a
    call m32_z80_mulu_de        ; x3*y0
    ex de,hl
    call m32_z80_mulu_de        ; y1*x2

    ex af,af
    add hl,de                   ; p4 p3
    adc a,0                     ; p5
    add hl,bc                   ; p4 p3
    adc a,0                     ; p5

    ex af,af
    ld a,l                      ; preserve p3 byte for rounding
    ex af,af

    ld c,h                      ; prepare BC for next cycle
    ld b,a                      ; promote BC p5 p4

    ; start doing the p4 byte

    pop hl                      ; x1 y1
    pop de                      ; x3 y3
    ld a,h
    ld h,d
    ld d,a
    call m32_z80_mulu_de        ; x1*y3
    ex de,hl
    call m32_z80_mulu_de        ; x3*y1


    xor a                       ; zero A
    add hl,de                   ; p5 p4
    adc a,a                     ; p6
    add hl,bc                   ; p5 p4
    adc a,0                     ; p6

    pop de                      ; x2 y2
    call m32_z80_mulu_de        ; x2*y2

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    ld c,l                      ; final p4 byte in C
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p6 p5

    ex af,af
    or a
    jr Z,mul0                   ; use p3 to round p4
    set 0,c

.mul0
    
    ; start doing the p5 byte

    pop de                      ; y3 x2
    call m32_z80_mulu_de        ; y3*x2

    xor a                       ; zero A
    add hl,de                   ; p6 p5
    adc a,a                     ; p7

    pop de                      ; x3 y2
    call m32_z80_mulu_de        ; x3*y2

    add hl,de                   ; p6 p5
    adc a,0                     ; p7

    ld b,l                      ; final p5 byte in B
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p7 p6

    ; start doing the p6 p7 bytes
    pop de                      ; y3 x3
    call m32_z80_mulu_de        ; y3*x3

    add hl,de                   ; p7 p6
    ex de,hl                    ; p7 p6
    ld h,b                      ; p5
    ld l,c                      ; p4
    ret                         ; exit  : DEHL = 32-bit product

ELSE

    ; start doing the p3 byte

    pop hl                      ; y3 y2
    ld a,h
    ld h,d
    ld d,a
;;; MLT HL (BC) ;;;;;;;;;;;;;;;;; x1*y2
    ld b,h                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y3*x0
    ld b,d                      ; 4  operand Y in B
    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p4 p3
    adc a,a                     ; p5
    ex af,af

    pop bc                      ; x3 x2
    pop de                      ; y1 y0
    ld a,b
    ld b,d
    ld d,a
    push bc                     ; y1 x2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y0
    ld b,d                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ex af,af
    add hl,de                   ; p4 p3
    adc a,0                     ; p5
    pop de                      ; y1 x2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y1*x2
    ld b,d                      ; 4  operand Y in B
    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
    add hl,de                   ; p4 p3
    adc a,0                     ; p5

    ex af,af
    ld a,l                      ; preserve p3 byte for rounding
    ex af,af

    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p5 p4

    ; start doing the p4 byte

    pop bc                      ; x1 y1
    pop de                      ; x3 y3
    ld a,b
    ld b,d
    ld d,a
    push bc                     ; x3 y1
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x1*y3
    ld b,d                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p5 p4
    adc a,a                     ; p6
    pop de                      ; x3 y1
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y1
    ld b,d                      ; 4  operand Y in B
    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    pop de                      ; x2 y2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x2*y2
    ld b,d                      ; 4  operand Y in B
    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    ld c,l                      ; final p4 byte in C
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p6 p5

    ex af,af                    ; p3 byte for rounding
    or a
    jr Z,mul0                   ; use p3 to round p4
    set 0,c

.mul0
    ; start doing the p5 byte

    pop de                      ; y3 x2
    push bc                     ; save p4 byte

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y3*x2
    ld b,d                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor a                       ; zero A
    add hl,de                   ; p6 p5
    adc a,a                     ; p7

    pop bc                      ; save p4 byte
    pop de                      ; x3 y2
    push bc                     ; save p4 byte

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x3*y2
    ld b,d                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p6 p5
    adc a,0                     ; p7

    pop bc                      ; save p4 byte in C
    ld b,l                      ; final p5 byte in B
    ld l,h                      ; prepare HL for next cycle
    ld h,a                      ; promote HL p7 p6

    ; start doing the p6 p7 bytes

    pop de                      ; y3 x3
    push bc                     ; save p5 p4 byte in BC

;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; y3*x3
    ld b,d                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p7 p6 in HL
    pop de                      ; save p5 p4 byte in DE
    ex de,hl                    ; p7 p6 p5 p4
    ret                         ; exit  : DEHL = 32-bit product

ENDIF
ENDIF
