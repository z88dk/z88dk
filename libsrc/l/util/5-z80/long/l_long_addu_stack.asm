
SECTION code_clib
SECTION code_l

PUBLIC l_long_addu_stack

EXTERN error_lmc

l_long_addu_stack:

   ; compute a = a + b
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl  = a + b, max $ ffff ffff
   ;         carry set on overflow
   ;
   ; uses  : f, bc, de, hl, ix
   
   pop ix
   
   pop bc
   add hl,bc
   ex de,hl
   
   pop bc
   adc hl,bc
   ex de,hl
   
   call c, error_lmc
   jp (ix)
