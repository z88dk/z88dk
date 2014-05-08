
PUBLIC l_long_addu_exx

l_long_addu_exx:

   ; compute a += b
   ;
   ; enter : dehl'= long a
   ;         dehl = long b
   ;
   ; exit  : dehl = a + b, max $ ffff ffff
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
   
   ret nc
   
   ld de,$ffff
   ld l,e
   ld h,d
   ret
