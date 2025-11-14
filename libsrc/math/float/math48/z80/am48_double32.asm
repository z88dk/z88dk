
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double32

EXTERN am48_double32u, l_neg_dehl

am48_double32:

   ; 32-bit signed long to double
   ;
   ; enter : DEHL = 32-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,d
   or a
   jp p, am48_double32u        ; if n >= 0

   call l_neg_dehl             ; n = |n|
   call am48_double32u
   
   exx
   set 7,b
   exx
   
   ret
