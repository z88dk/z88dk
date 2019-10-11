; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_64_32x32, l0_z80n_mulu_64_32x32

l_z80n_mulu_64_32x32:

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

l0_z80n_mulu_64_32x32:

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

    ; save material for the byte p3 = x3*y0 + x2*y1 + x1*y2 + x0*y3 + p2 carry
    push bc                     ; y1 y0
    exx                         ;'
    push de                     ;'x3 x2
    push bc                     ;'y3 y2
    exx                         ;
    push de                     ; x1 x0

    ; save material for the byte p2 = x2*y0 + x0*y2 + x1*y1 + p1 carry
    ; start of 32_32x32
    exx                         ;'
    ld h,e
    ld l,c
    push hl                     ;'x2 y2

    exx                         ;
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

    exx                         ;'
    pop bc                      ;'recover interim p3 p2

    pop hl                      ;'x0 y0
    pop de                      ;'x2 y2
    ld a,h
    ld h,d
    ld d,a
    mul de                      ;'x0*y2
    ex de,hl
    mul de                      ;'x2*y0

    xor a
    add hl,bc
    adc a,a                     ;'capture carry p4
    add hl,de
    adc a,0                     ;'capture carry p4

    push hl
    exx
    pop de                      ; save p2 in E'
    exx                         ;'

    ld c,h                      ;'promote BC p4 p3
    ld b,a 

    ; start doing the p3 byte

    pop hl                      ;'x1 x0
    pop de                      ;'y3 y2
    ld a,h
    ld h,d
    ld d,a
    mul de                      ;'y3*x0
    ex de,hl
    mul de                      ;'x1*y2

    xor a                       ;'zero A
    add hl,de                   ;'p4 p3
    adc a,a                     ;'p5
    add hl,bc                   ;'p4 p3
    adc a,0
    ld b,h
    ld c,l
    ex af,af

    pop hl                      ;'x3 x2
    pop de                      ;'y1 y0
    ld a,h
    ld h,d
    ld d,a
    mul de                      ;'x3*y0
    ex de,hl
    mul de                      ;'y1*x2

    ex af,af
    add hl,de                   ;'p4 p3
    adc a,0                     ;'p5
    add hl,bc                   ;'p4 p3
    adc a,0                     ;'p5

    push hl                     ;'leave final p3 in L   
    exx                         ; 
    pop bc
    ld d,c                      ; put final p3 in D
    exx                         ;'low 32bits in DEHL

    ld c,h                      ;'prepare BC for next cycle
    ld b,a                      ;'promote BC p5 p4

    ; start doing the p4 byte

    pop hl                      ;'x1 y1
    pop de                      ;'x3 y3
    ld a,h
    ld h,d
    ld d,a
    mul de                      ;'x1*y3
    ex de,hl
    mul de                      ;'x3*y1


    xor a                       ;'zero A
    add hl,de                   ;'p5 p4
    adc a,a                     ;'p6
    add hl,bc                   ;'p5 p4
    adc a,0                     ;'p6

    pop de                      ;'x2 y2
    mul de                      ;'x2*y2

    add hl,de                   ;'p5 p4
    adc a,0                     ;'p6

    ld c,l                      ;'final p4 byte in C
    ld l,h                      ;'prepare HL for next cycle
    ld h,a                      ;'promote HL p6 p5

    ; start doing the p5 byte

    pop de                      ;'y3 x2
    mul de                      ;'y3*x2

    xor a                       ;'zero A
    add hl,de                   ;'p6 p5
    adc a,a                     ;'p7

    pop de                      ;'x3 y2
    mul de                      ;'x3*y2

    add hl,de                   ;'p6 p5
    adc a,0                     ;'p7

    ld b,l                      ;'final p5 byte in B
    ld l,h                      ;'prepare HL for next cycle
    ld h,a                      ;'promote HL p7 p6

    ; start doing the p6 p7 bytes
    pop de                      ;'y3 x3
    mul de                      ;'y3*x3

    add hl,de                   ;'p7 p6
    ex de,hl                    ;'p7 p6
    ld h,b                      ;'p5
    ld l,c                      ;'p4

    xor a                       ;'carry reset
    ret                         ;'exit  : DEHL DEHL' = 64-bit product

