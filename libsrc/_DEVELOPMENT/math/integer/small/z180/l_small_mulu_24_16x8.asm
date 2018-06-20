SECTION code_clib
SECTION code_math

PUBLIC l_small_mulu_24_16x8

l_small_mulu_24_16x8:

   ; multiplication of 16-bit number and 8-bit number into a 24-bit product
   ;
   ; enter : hl = 16-bit multiplier   = x
   ;          e =  8-bit multiplicand = y
   ;
   ; exit  : ahl = 24-bit product
   ;         carry reset
   ;
   ; uses  : af, de, hl

   ld d,h                      ; xh
   ld h,e                      ; yl

   mlt hl                      ; yl * xl
   mlt de                      ; xh * yl

   ld  a,h                     ; sum products
   add a,e
   ld  h,a

   ld  a,d
   ret NC                      ; return if no carry
   inc a
   ret

