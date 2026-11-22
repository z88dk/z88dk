
SECTION code_clib
SECTION code_l

PUBLIC l_ltu_bc_de

l_ltu_bc_de:

   ; bc < de ?

   ; enter : de = unsigned int
   ;         bc = unsigned int
   ;
   ; exit  : carry set if bc<de, a<0
   ;         z     set if bc=de, a=0
   ;         p,nc  set if bc>=de, a>=0
   ;         a>0       if bc>de
   ;
   ; uses  : af
   
   ld a,b
   sub d
   ret nz
   
   ld a,c
   sub e
   ret
