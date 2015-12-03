
SECTION code_clib
SECTION code_l

PUBLIC l_long_sbc_stack

l_long_sbc_stack:

   ; compute a = a - b - carry
   ;
   ; enter : dehl  = long a
   ;         stack = long b, return address
   ;
   ; exit  : dehl = a - b - carry
   ;         carry set on overflow
   ;
   ; uses  : f, bc, de, hl, ix
   
   pop ix
   
   pop bc
   sbc hl,bc
   
   pop bc
   ex de,hl
   sbc hl,bc
   ex de,hl
   
   jp (ix)
