
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_deq_s

EXTERN am48_deq

am48_deq_s:

   ; Return bool (double == AC')
   ;
   ; enter :    AC'= double y
   ;         stack = double x, ret
   ;
   ; exit  : HL = 0 and carry reset if false
   ;         HL = 1 and carry set if true
   ;
   ; uses  : af, bc, de, hl
   
   pop af
   
   pop hl
   pop de
   pop bc
   
   push af
   
   jp am48_deq
