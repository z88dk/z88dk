
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dsigdig

am48_dsigdig:

   ; exit  : b = number of significant hex digits in double representation
   ;         c = number of significant decimal digits in double representation
   ;
   ; uses  : bc

   ld bc,$0a0b
   ret
