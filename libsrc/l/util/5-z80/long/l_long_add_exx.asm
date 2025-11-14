
SECTION code_clib
SECTION code_l

PUBLIC l_long_add_exx

l_long_add_exx:

   ; compute a += b
   ;
   ; enter : dehl'= long a
   ;         dehl = long b
   ;
   ; exit  : dehl = a + b
   ;         dehl'= long b 
   ;         exx set active on exit
   ;         carry set on overflow
   ;
   ; uses  : f, (bc, de, hl) of exx set

   push de
   push hl
   
   exx
   
   pop bc                      ; bc = b.LSW
   add hl,bc
   ex de,hl
   
   pop bc                      ; bc = b.MSW
   adc hl,bc
   ex de,hl
   
   ret
