
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dpush

am48_dpush:

   ; push AC' onto the stack
   ;
   ; enter : stack = ret
   ;
   ; exit  : stack = double
   ;
   ; uses : af
   
   exx
   
   pop af
   
   push bc
   push de
   push hl
   
   push af
   
   exx
   ret
