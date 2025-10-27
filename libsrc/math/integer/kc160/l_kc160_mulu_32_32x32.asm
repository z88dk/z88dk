
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_mulu_32_32x32
PUBLIC l0_kc160_mulu_32_32x32

EXTERN l_kc160_mulu_64_32x32, l0_kc160_mulu_64_32x32

   ; multiplication of two 32-bit numbers into a 32-bit product
   ;
   ; enter : dehl = 32-bit multiplicand (more zeros = better performance)
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
l_kc160_mulu_32_32x32:
    ld bc,hl
    push de
    exx
    pop bc
    push hl
    exx
    pop de
    exx

l0_kc160_mulu_32_32x32:
    ; multiplication of two 32-bit numbers into a 42-bit product
    ;
    ; enter : dede' = 32-bit multiplier    = x
    ;         bcbc' = 32-bit multiplicand  = y
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'
    exx

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

    ;(B*D)
    ld hl,(ix-6)
    ld de,(ix-2)
    ld  a,1
    mul de,hl
    push hl
    push de

    ;(A*D) << 16
    ld hl,(ix-8)
    ld de,(ix-2)
    ld  a,2
    mul de,hl
    pop bc
    add hl,bc
    push hl
    
    ;(B*C) << 16
    ld hl,(ix-6)
    ld de,(ix-4)
    ld  a,3
    mul de,hl
    pop bc
    add hl,bc
    ex de,hl
    pop hl
    
    ld sp,ix
    pop ix
    and a
    ret
   


