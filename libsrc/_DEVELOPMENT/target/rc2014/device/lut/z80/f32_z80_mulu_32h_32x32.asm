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

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; feilipu, 2021 April
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
;
; enter : dehl  = 32-bit multiplicand  = x   x1x0
;         dehl' = 32-bit multiplier    = y   y1y0
;
; exit  : dehl  = 32-bit product = z  z3z2 = y1y0 * x1x0
;         carry reset
;
; uses  : af, bc, de, hl, bc', de', hl'

IF __IO_LUT_MODULE_AVAILABLE == 0


.m32_mulu_32h_32x32

    push de                     ; preserve multiplicand x1
    push de                     ; x1
    exx

    pop bc                      ; x1
    push de                     ; preserve multiplier y1
    push bc                     ; x1

    push hl                     ; preserve multiplier y0
    push de                     ; preserve multiplier y1

    push hl                     ; preserve multiplier y0
    exx

    pop de                      ; y0
    push hl                     ; preserve multiplicand x0

    ; multiply lowest term y0*x0
    call mulu_32_16x16          ; de*hl -> dehl

    ex de,hl                    ; hlde z1 (partial)
    pop de                      ; x0
    ex (sp),hl                  ; y1 z1 (partial), abandon z0

    ; multiply middle term x0*y1
    call mulu_32_16x16          ; de*hl -> dehl

    pop bc
    add hl,bc                   ; z1 (partial)
    ld b,h
    ld c,l

    ld hl,0
    adc hl,de                   ; z2 (partial)
    ex de,hl
    exx                         ; z2z1 (partial) de'bc'

    pop de                      ; y0
    pop hl                      ; x1

    ; multiply middle term y0*x1
    call mulu_32_16x16          ; de*hl -> dehl

    push de
    push hl
    exx

    pop hl
    add hl,bc                   ; z1 capture carry and abandon

    pop hl
    adc hl,de                   ; z2 (partial)
    ex de,hl

    ld bc,0
    rl c                        ; z3 (partial)

    exx                         ; z3z2 (partial) bc'de'

    pop de                      ; y1
    pop hl                      ; x1

    ; multiply top term y1*x1
    call mulu_32_16x16          ; de*hl -> dehl

    push de
    push hl
    exx

    pop hl
    add hl,de
    ex de,hl                    ; z2

    pop hl
    adc hl,bc                   ; z3

    ex de,hl                    ; z3z2 dehl

    ret                         ; exit  : DEHL = 32-bit product


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

ELSE ;  feilipu, 2020 February

    ; start doing the p3 byte

    pop hl                      ; y3 y2

;;; MLT DL (BC) ;;;;;;;;;;;;;;;;; x1*y2
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;; MLT HE (BC) ;;;;;;;;;;;;;;;;; y3*x0
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
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
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    add hl,de                   ; p5 p4
    adc a,0                     ; p6

    pop de                      ; x2 y2
;;; MLT DE (BC) ;;;;;;;;;;;;;;;;; x2*y2
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
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
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,d                      ; 4  operand Y in B
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
