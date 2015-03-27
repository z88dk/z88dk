
SECTION code_fp_math48

PUBLIC mm48__zero

mm48__zero:

   ;Nulstil AC.

   xor a                       ;Nulstil carry, expo-
   ld l,a                      ;nent og mantissa
   ld b,a
   ld c,a
   ld d,a
   ld e,a
   ld h,a
   ret
