
SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_16_16x8

   ex de,hl

l_z80n_mulu_16_16x8:

   ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
   ;
   ; enter :  l = 8-bit multiplicand
   ;         de = 16-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;         carry reset
   ;
   ; uses  : af, de, hl

   ld h,e                      ; h = yl
   ld e,l                      ; e = x

   mul de                      ; x * yh
   ex de,hl
   mul de                      ; x * yl

   ld a,l                      ; cross product lsb
   add a,d                     ; add to msb final
   ld h,a
   ld l,e                      ; hl = final

   ; 44 cycles, 11 bytes

   xor a
   ret
