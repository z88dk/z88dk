
SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_72_64x8

EXTERN l_small_mul_40_32x8

l_small_mul_72_64x8:

   ; multiplication of a 64-bit number and an 8-bit number into 72-bit result
   ;
   ; enter :   dehl'dehl = 64-bit multiplicand
   ;                   a = 8-bit multiplicand
   ;
   ; exit  : a dehl'dehl = 72-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   exx
   
   push de
   push hl                     ; save MS32
   push af                     ; save M8
   
   exx
   
   call l_small_mul_40_32x8    ; adehl = LS32 * M8
   
   ld c,a
   ld b,0
   
   exx
   
   pop af                      ; a = M8
   pop hl
   pop de                      ; dehl = MS32
   
   exx
   
   push de
   push hl
   push bc                     ; save LS32 * M8
   
   exx
   
   call l_small_mul_40_32x8    ; adehl = MS32 * M8
   
   pop bc
   add hl,bc
   
   jr nc, no_propagate
   
   inc e
   jr nz, no_propagate
   
   inc d
   jr nz, no_propagate
   
   inc a
   
no_propagate:

   exx
   
   pop hl
   pop de                      ; a dehl'dehl = 72-bit product
   
   or a
   ret
