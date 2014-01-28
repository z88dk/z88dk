
XLIB l_add_long_stk

l_add_long_stk:

   ; compute a = a + b
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl  = a + b
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
