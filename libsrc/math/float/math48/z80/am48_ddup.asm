
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ddup

am48_ddup:

   ; duplicate double on top of stack
   ;
   ; enter : stack = double x, ret
   ;
   ; exit  :    AC = double x
   ;         stack = double x, double x
   ;
   ; uses  : af, bc, de, hl

   pop af
   
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   
   push bc
   push de
   push hl
   
   push af
   ret
