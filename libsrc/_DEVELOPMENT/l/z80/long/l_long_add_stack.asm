
SECTION code_clib
SECTION code_l

PUBLIC l_long_add_stack

l_long_add_stack:

   ; compute a = a + b
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl  = a + b
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
   
   jp (ix)
