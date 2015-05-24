
SECTION code_fp_math48

PUBLIC mm48_float_long

EXTERN mm48_ufloat_long, l_neg_dehl

mm48_float_long:

   ; 32-bit signed long to floating point number
   ;
   ; enter : DEHL = 32-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (float)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ld a,d
   or a
   jp p, mm48_ufloat_long      ; if n >= 0

   call l_neg_dehl             ; n = |n|
   call mm48_ufloat_long
   
   exx
   set 7,b
   exx
   
   ret
