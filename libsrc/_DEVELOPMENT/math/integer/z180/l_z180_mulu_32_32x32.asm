; 2018 June feilipu

SECTION code_clib
SECTION code_math

EXTERN l_z180_mulu_32_16x16

PUBLIC l_z180_mulu_32_32x32, l0_z180_mulu_32_32x32

l0_z180_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl'= 16-bit multiplier   = y
    ;         hl = 16-bit multiplicand = x
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    push hl
    exx
    pop de
    jp l_z180_mulu_32_16x16

l_z180_mulu_32_32x32:

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
    jr Z,l0_z180_mulu_32_16x16  ; demote if both are uint16_t

    push hl
    exx
    ld c,l
    ld b,h
    pop hl
    push de
    ex de,hl
    exx
    pop bc

l0_z180_mulu_32_32x32:

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
    push de                     ; x3 x2
    exx
    push bc                     ; y1 y0
    push de                     ; x1 x0
    exx
    push bc                     ; y3 y2

    ; save material for the byte p2 = x2*y0 + x0*y2 + x1*y1 + p1 carry
    ; start of 32_32x32

    ld h,e
    ld l,c
    push hl                     ; x2 y2

    exx                         ; now we're working in the low order bytes
    ld h,e
    ld l,c
    push hl                     ; x0 y0

    ; start of 32_16x16          p1 = x1*y0 + x0*y1 + p0 carry
    ;                            p0 = x0*y0

    ld h,d
    ld l,b
    push hl                     ; x1 y1

    ld h,d                      ; x1
    ld l,c                      ; y0

    ld d,c                      ; y0 e = x0
    ld c,e                      ; x0 b = y1

    ; bc = x0 y1
    ; de = x0 y0
    ; hl = x1 y0
    ; stack = x1 y1

    mlt de                      ; x0*y0
    mlt bc                      ; x0*y1
    mlt hl                      ; x1*y0

    xor a                       ; zero A
    add hl,bc                   ; sum cross products p2 p1
    adc a,a                     ; capture carry p3
    ld b,a
    ld c,h                      ; LSB of MSW from cross products

    ld a,d
    add a,l
    ld d,a                      ; LSW in DE p1 p0

    pop hl
    mlt hl                      ; x1*y1

    adc hl,bc                   ; HL = interim MSW p3 p2
    ex de,hl                    ; DEHL = end of 32_16x16

    push de                     ; stack interim p3 p2

    ; continue doing the p2 byte

    exx                         ; now we're working in the high order bytes
                                ; DEHL' = end of 32_16x16
    pop hl                      ; destack interim p3 p2

    pop bc                      ; x0 y0
    pop de                      ; x2 y2
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ; x2*y0
    mlt de                      ; x0*y2
    add hl,bc
    add hl,de

    ; start doing the p3 byte

    pop bc                      ; y3 y2
    pop de                      ; x1 x0
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ; x1*y2
    mlt de                      ; y3*x0

    ld a,h                      ; work with existing p3 from H
    add a,c                     ; add low bytes of products
    add a,e

    pop bc                      ; y1 y0
    pop de                      ; x3 x2
    ld h,b
    ld b,d
    ld d,h
    mlt bc                      ; x3*y0
    mlt de                      ; y1*x2

    add a,c                     ; add low bytes of products
    add a,e
    ld h,a                      ; put final p3 back in H

    push hl

    exx                         ; now we're working in the low order bytes, again
    pop de
    xor a                       ; carry reset
    ret                         ; exit  : DEHL = 32-bit product
