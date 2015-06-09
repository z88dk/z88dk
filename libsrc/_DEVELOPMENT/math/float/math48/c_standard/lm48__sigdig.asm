
SECTION code_fp_math48

PUBLIC lm48__sigdig

lm48__sigdig:

   ; exit  : b = number of significant hex digits in float representation
   ;         c = number of significant decimal digits in float representation
   ;
   ; uses  : bc

   ld bc,$0a0d
   ret
