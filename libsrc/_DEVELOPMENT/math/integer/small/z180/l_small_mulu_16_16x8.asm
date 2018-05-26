SECTION code_clib
SECTION code_math

PUBLIC l_small_mulu_16_16x8

;  ex de,hl

l_small_mulu_16_16x8:

   ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
   ;
   ; enter :  l =  8-bit multiplier
   ;         de = 16-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld c,l
   ld b,d
   mlt bc                      ; x * yh
   ld h,e
   mlt hl                      ; x * yl
   ld a,c                      ; cross product lsb
   add a,h                     ; add to msb final
   ld h,a                      ; hl = final
   
   or a
   ret
