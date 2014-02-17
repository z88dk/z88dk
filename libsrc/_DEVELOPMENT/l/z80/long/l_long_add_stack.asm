
XLIB l_long_add_stack

l_long_add_stack:

   ; compute a = a + b
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl  = a + b
   ;         carry set on overflow
   ;
   ; uses  : f, de, hl, ix
   
   pop ix
   
   pop bc
   add hl,bc
   ex de,hl
   
   pop bc
   adc hl,bc
   ex de,hl
   
   jp (ix)
