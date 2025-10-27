
SECTION code_clib
SECTION code_l

PUBLIC l_ltu_hl_bc

l_ltu_hl_bc:

   ; hl < bc ?

   ; enter : hl = unsigned int
   ;         bc = unsigned int
   ;
   ; exit  : carry set if hl<bc, a<0
   ;         z     set if hl=bc, a=0
   ;         p,nc  set if hl>=bc, a>=0
   ;         a>0       if hl>bc
   ;
   ; uses  : af
   
   ld a,h
   sub b
   ret nz
   
   ld a,l
   sub c
   ret
