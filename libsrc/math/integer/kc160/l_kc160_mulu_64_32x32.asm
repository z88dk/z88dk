
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_mulu_64_32x32
PUBLIC l0_kc160_mulu_64_32x32

   ; multiplication of two 32-bit numbers into a 64-bit product
   ;
   ; enter : dehl = 32-bit multiplicand (more zeros = better performance)
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : dehl dehl' = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

l_kc160_mulu_64_32x32:
    ld bc,hl
    push de
    exx
    pop bc
    push hl
    exx
    pop de

l0_kc160_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : de'de = 32-bit multiplier    = x
    ;         bc'bc = 32-bit multiplicand  = y
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'


; AB * CD = (A*C << 32) + ((B*C + A*D) << 16) + B*D
; = ( de'*bc' << 32) + ((de*bc' + de'*bc) << 16) + de*bc

    push ix
    ld ix,sp
    push bc    ;(ix-2) = D
    exx
    push bc    ;(ix-4) = C
    exx
    push de    ;(ix-6) = B
    exx
    push de    ;(ix-8) = A
    ld hl,0    
    push hl    ;(ix-10) = LSB result
    push hl    ;(ix-12) = MSB result
    push hl    ;(ix-14) = MLSB result
    push hl    ;(ix-16) = MMSB result

    ;(B*D)
    ld hl,(ix-6)
    ld de,(ix-2)
    ld a,10
    mul de,hl
    ld (ix-10),hl
    ld (ix-12),de

    ;(A*D) << 16
    ld hl,(ix-8)
    ld de,(ix-2)
    ld a,11
    mul de,hl
    ld bc,(ix-12)
    add hl,bc
    ld (ix-12),hl
    ld hl,(ix-14)
    adc hl,de
    ld (ix-14),hl

    ;(B*C) << 16
    ld hl,(ix-6)
    ld de,(ix-4)
    ld a,12
    mul de,hl
    ld bc,(ix-12)
    add hl,bc
    ld (ix-12),hl
    ld hl,(ix-14)
    adc hl,de
    ld (ix-14),hl
    ld hl,(ix-16)
    ld de,0
    adc hl,de
    ld (ix-16),hl

    ; (A*C << 32)
    ld hl,(ix-8)
    ld de,(ix-4)
    ld a,13
    mul de,hl
    ld bc,(ix-14)
    add hl,bc
    ld (ix-14),hl
    ld hl,(ix-16)
    adc hl,de
    ld (ix-16),hl

   
    ; exit  : dehl dehl' = 64-bit product
    ld hl,(ix-10)
    ld de,(ix-12)
    exx
    ld hl,(ix-14)
    ld de,(ix-16)


    ld sp,ix
    pop ix
    and a
    ret
   

