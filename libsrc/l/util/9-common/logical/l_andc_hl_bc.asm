
SECTION code_clib
SECTION code_l

PUBLIC l_andc_hl_bc

l_andc_hl_bc:

   ; enter : hl, bc
   ;
   ; exit  : hl = hl & (~bc)
   ;         carry reset
   ;
   ; uses  : af, hl

   ld a,c
   cpl
   and l
   ld l,a
   
   ld a,b
   cpl
   and h
   ld h,a
   
   ret
