
SECTION code_clib
SECTION code_l

PUBLIC l_ex_bc_de

l_ex_bc_de:

   ; enter : bc = A
   ;         de = B
   ;
   ; exit  : bc = B
   ;         de = A
   ;
   ; uses  : a, bc, de
   
   ld a,e
   ld e,c
   ld c,a
   
   ld a,d
   ld d,b
   ld b,a
   
   ret
