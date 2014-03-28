
XLIB l_long_addu_stack

l_long_addu_stack:

   ; compute a = a + b
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl  = a + b, max $ ffff ffff
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
   
   jr c, oflow
   jp (ix)

oflow:

   ld de,$ffff
   ld l,e
   ld h,d
   
   jp (ix)
