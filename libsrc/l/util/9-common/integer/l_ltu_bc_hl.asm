
SECTION code_clib
SECTION code_l

PUBLIC l_ltu_bc_hl

l_ltu_bc_hl:

   ; bc < hl ?

   ; enter : hl = unsigned int
   ;         bc = unsigned int
   ;
   ; exit  : carry set if bc<hl, a<0
   ;         z     set if bc=hl, a=0
   ;         p,nc  set if bc>=hl, a>=0
   ;         a>0       if bc>hl
   ;
   ; uses  : af
   
   ld a,b
   sub h
   ret nz
   
   ld a,c
   sub l
   ret
