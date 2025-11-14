
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double16

EXTERN am48_double16u, l_neg_hl

am48_double16:

   ; 16-bit integer to double
   ;
   ; enter : HL = 16-bit integer n
   ;
   ; exit  : AC = AC' (AC' saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld a,h
   or a
   jp p, am48_double16u        ; if n >= 0
   
   call l_neg_hl               ; n = |n|
   call am48_double16u
   
   exx
   set 7,b
   exx
   
   ret
