
SECTION code_fp_math48

PUBLIC lm48__fta_sgnabs

lm48__fta_sgnabs:

   ; enter : EXX = float x
   ;
   ; exit  :   x = |x|
   ;           a = sgn(x) = 1 if negative, 0 otherwise
   ;
   ; uses  : af
   
   exx
   ld a,b
   res 7,b
   exx
   
   rlca
   and $01
   
   ret
