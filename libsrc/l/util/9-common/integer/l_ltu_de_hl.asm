
SECTION code_clib
SECTION code_l

PUBLIC l_ltu_de_hl

l_ltu_de_hl:

   ; de < hl ?
   
   ; enter : hl = unsigned int
   ;         de = unsigned int
   ;
   ; exit  : carry set if de<hl, a<0
   ;         z     set if de=hl, a=0
   ;         p,nc  set if de>=hl, a>=0
   ;         a>0       if de>hl
   ;
   ; uses  : af
   
   ld a,d
   sub h
   ret nz
   
   ld a,e
   sub l
   ret
