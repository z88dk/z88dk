
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fssigdig

m32_fssigdig:

   ; exit  : b = number of significant hex digits in double representation
   ;         c = number of significant decimal digits in double representation
   ;
   ; uses  : bc

   ld bc,$0607
   ret
