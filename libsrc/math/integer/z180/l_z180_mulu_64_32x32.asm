; 2018 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_64_32x32, l0_z180_mulu_64_32x32

l_z180_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : dehl = 32-bit multiplicand
    ;         dehl'= 32-bit multiplicand
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    ld bc,hl
    push de
    exx
    pop bc
    push hl
    exx
    pop de

l0_z180_mulu_64_32x32:

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
    ex de,hl                    ; DEHL = 32_16x16

    push de                     ; stack interim p3 p2

    ; continue doing the p2 byte

    exx                         ; 'now we're working in the high order bytes
                                ; DEHL' = end of 32_16x16
    pop hl                      ; 10'destack interim p3 p2

    pop bc                      ;'x0 y0
    pop de                      ;'x2 y2
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ;'x2*y0
    mlt de                      ;'x0*y2

    xor a
    add hl,bc
    adc a,a                     ;'capture carry p4
    add hl,de
    adc a,0                     ;'capture carry p4

    push hl
    exx
    pop de                      ; save p2 in E'
    exx                         ;'

    ld l,h                      ;'promote HL p4 p3
    ld h,a 

    ; start doing the p3 byte

    pop bc                      ;'x1 x0
    pop de                      ;'y3 y2
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ;'x1*y2
    mlt de                      ;'y3*x0

    xor a                       ;'zero A
    add hl,de                   ;'p4 p3
    adc a,a                     ;'p5
    add hl,bc                   ;'p4 p3
    adc a,0
    ex af,af

    pop bc                      ;'x3 x2
    pop de                      ;'y1 y0
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ;'y1*x2
    mlt de                      ;'x3*y0

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

    ld l,h                      ;'prepare HL for next cycle
    ld h,a                      ;'promote HL p5 p4

    ; start doing the p4 byte

    pop bc                      ;'x1 y1
    pop de                      ;'x3 y3
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ;'x3*y1
    mlt de                      ;'x1*y3    

    xor a                       ;'zero A
    add hl,de                   ;'p5 p4
    adc a,a                     ;'p6
    add hl,bc                   ;'p5 p4
    adc a,0                     ;'p6

    pop bc                      ;'x2 y2
    mlt bc                      ;'x2*y2

    add hl,bc                   ;'p5 p4
    adc a,0                     ;'p6

    ld e,l                      ;'final p4 byte in E
    ld l,h                      ;'prepare HL for next cycle
    ld h,a                      ;'promote HL p6 p5

    ; start doing the p5 byte

    pop bc                      ;'y3 x2
    mlt bc                      ;'y3*x2

    xor a                       ;'zero A
    add hl,bc                   ;'p6 p5
    adc a,a                     ;'p7

    pop bc                      ;'x3 y2
    mlt bc                      ;'x3*y2

    add hl,bc                   ;'p6 p5
    adc a,0                     ;'p7

    ld d,l                      ;'final p5 byte in D
    ld l,h                      ;'prepare HL for next cycle
    ld h,a                      ;'promote HL p7 p6

    ; start doing the p6 p7 bytes
    pop bc                      ;'y3 x3
    mlt bc                      ;'y3*x3

    add hl,bc                   ;'p7 p6
    ex de,hl                    ;'p7 p6 <-> p5 p4

    ret                         ;'exit  : DEHL DEHL' = 64-bit product
