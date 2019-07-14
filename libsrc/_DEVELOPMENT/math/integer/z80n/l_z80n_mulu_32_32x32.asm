; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_32_32x32, l0_z80n_mulu_32_32x32

l_z80n_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : dehl = 32-bit multiplicand
    ;         dehl'= 32-bit multiplicand
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    push hl
    exx
    ld c,l
    ld b,h
    pop hl
    push de
    ex de,hl
    exx
    pop bc

l0_z80n_mulu_32_32x32:

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
    ld d,b                      ; y1
    ld l,c                      ; y0
    ld b,e                      ; x0 

   ; bc = x0 y0
   ; de = y1 x0
   ; hl = x1 y0
   ; stack = x1 y1

    mul de                      ; y1*x0
    ex de,hl
    mul de                      ; x1*y0

    xor a                       ; zero A
    add hl,de                   ; sum cross products p2 p1
    adc a,a                     ; capture carry p3

    ld e,c                      ; x0
    ld d,b                      ; y0
    mul de                      ; y0*x0

    ld b,a                      ; carry from cross products
    ld c,h                      ; LSB of MSW from cross products

    ld a,d
    add a,l
    ld h,a
    ld l,e                      ; LSW in HL p1 p0

    pop de
    mul de                      ; x1*y1

    ex de,hl
    adc hl,bc                   ; HL = interim MSW p3 p2
                                ; 32_16x16 = HLDE

    push hl                     ; stack interim p3 p2
    ex de,hl                    ; p1 p0 in HL

    ; continue doing the p2 byte

    exx                         ; now we're working in the high order bytes
                                ; DEHL' = end of 32_16x16
    pop bc                      ; stack interim p3 p2

    pop hl                      ; x0 y0
    pop de                      ; x2 y2
    ld a,h
    ld h,d
    ld d,a
    mul de                      ; x0*y2
    ex de,hl
    mul de                      ; x2*y0

    add hl,bc
    add hl,de
    ld b,h
    ld c,l

    ; start doing the p3 byte

    pop hl                      ; y3 y2
    pop de                      ; x1 x0
    ld a,h
    ld h,d
    ld d,a
    mul de                      ; y3*x0
    ex de,hl
    mul de                      ; x1*y2

    ld a,b                      ; work with existing p3 from B
    add a,e                     ; add low bytes of products
    add a,l

    pop hl                      ; y1 y0
    pop de                      ; x3 x2
    ld b,h
    ld h,d
    ld d,b
    mul de                      ; y1*x2
    ex de,hl
    mul de                      ; x3*y0


    add a,l                     ; add low bytes of products
    add a,e
    ld b,a                      ; put final p3 back in B

    push bc

    exx                         ; now we're working in the low order bytes, again
    pop de
    xor a                       ; carry reset
    ret                         ; exit  : DEHL = 32-bit product

