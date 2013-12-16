
XLIB l_andc_hlbc

l_andc_hlbc:

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
