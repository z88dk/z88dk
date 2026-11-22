
SECTION code_clib
SECTION code_l

PUBLIC l_ex_bc_hl

l_ex_bc_hl:

   ; enter : bc = A
   ;         hl = B
   ;
   ; exit  : bc = B
   ;         hl = A
   ;
   ; uses  : a, bc, hl
   
   ld a,l
   ld l,c
   ld c,a
   
   ld a,h
   ld h,b
   ld b,a
   
   ret
