
SECTION code_clib
SECTION code_l

PUBLIC l_ltu_hl_de

l_ltu_hl_de:

   ; hl < de ?

   ; enter : hl = unsigned int
   ;         de = unsigned int
   ;
   ; exit  : carry set if hl<de, a<0
   ;         z     set if hl=de, a=0
   ;         p,nc  set if hl>=de, a>=0
   ;         a>0       if hl>de
   ;
   ; uses  : af
   
   ld a,h
   sub d
   ret nz
   
   ld a,l
   sub e
   ret
