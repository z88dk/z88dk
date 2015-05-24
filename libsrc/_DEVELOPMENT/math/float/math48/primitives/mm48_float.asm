
SECTION code_fp_math48

PUBLIC mm48_float

EXTERN mm48_ufloat, l_neg_hl

mm48_float:

   ; 16-bit integer to floating point number
   ;
   ; enter : HL = 16-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (float)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld a,h
   or a
   jp p, mm48_ufloat           ; if n >= 0
   
   call l_neg_hl               ; n = |n|
   call mm48_ufloat
   
   exx
   set 7,b
   exx
   
   ret
