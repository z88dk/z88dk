
SECTION code_clib
SECTION code_l

PUBLIC l_andc_hl_de

l_andc_hl_de:

   ; enter : hl, de
   ;
   ; exit  : hl = hl & (~de)
   ;         carry reset
   ;
   ; uses  : af, hl
   
   ld a,e
   cpl
   and l
   ld l,a
   
   ld a,d
   cpl
   and h
   ld h,a
   
   ret
