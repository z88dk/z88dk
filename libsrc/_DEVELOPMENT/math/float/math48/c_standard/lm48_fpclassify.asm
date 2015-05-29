
SECTION code_fp_math48

PUBLIC lm48_fpclassify

lm48_fpclassify:

   ; enter : AC'= float x
   ;
   ; exit  :  a = 0 if number
   ;            = 1 if zero
   ;            = 2 if nan (not applicable for math48)
   ;            = 3 if inf (not applicable for math48)
   ;
   ; uses  : af
   
   exx
   ld a,l
   exx
   
   or a
   jr z, zero
   
   xor a
   ret

zero:

   inc a
   ret
