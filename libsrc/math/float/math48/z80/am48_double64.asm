
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double64

EXTERN am48_double64u, l_neg_64_dehldehl

am48_double64:

   ; 64-bit signed long long to double
   ;
   ; enter : dehl'dehl = 64-bit integer n
   ;
   ; exit  : AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   exx
   ld a,d
   exx

   or a
   jp p, am48_double64u        ; if n >= 0

   call l_neg_64_dehldehl      ; n = |n|
   call am48_double64u
   
   exx
   set 7,b
   exx
   
   ret
