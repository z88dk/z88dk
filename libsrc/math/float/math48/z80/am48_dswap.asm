
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dswap

am48_dswap:

   ; swap double on stack with AC'
   ;
   ; enter :    AC'= double x
   ;         stack = double y, ret
   ;
   ; exit  :    AC'= double y
   ;            AC = double x
   ;         stack = double x
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   
   pop hl
   pop de
   pop bc
   
   exx
   
   push bc
   push de
   push hl
   
   push af
   ret
