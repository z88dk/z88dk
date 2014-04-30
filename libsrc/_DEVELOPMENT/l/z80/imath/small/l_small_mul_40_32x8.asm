
XLIB l_small_mul_40_32x8

LIB l_small_mul_32_32x32, l0_small_mul_16_16x16

l_small_mul_40_32x8:

   ; multiplication of a 32-bit number and an 8-bit number into 40-bit result
   ;
   ; enter : dehl = 32-bit multiplicand
   ;            a = 8-bit multiplicand
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; split into two multiplications and add
   
   ld c,a
   ld b,d
   
   push bc                     ; save DA
   
   exx
   
   ld l,a
   xor a
   ld h,a
   ld e,a
   ld d,a
   
   exx
   
   ld d,a
   call l_small_mul_32_32x32   ; dehl = EHL * A

   ex (sp),hl                  ; hl = DA
   push de                     ; stack = hlde
   
   ld e,h
   xor a
   ld h,a
   ld d,a
   
   call l0_small_mul_16_16x16  ; hl = D * A
   
   pop de                      ; de = MSW(EHL * A)
   
   ld a,d
   add a,l
   ld d,a
   
   ld a,h
   adc a,0
   
   pop hl                      ; adehl = 40-bit result
   ret
