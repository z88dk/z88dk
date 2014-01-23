
XLIB l_saturated_inc_de

l_saturated_inc_de:

   ; uses : af, de
   ; carry reset

   inc de
   
   ld a,d
   or e
   ret nz
   
   ld de,$ffff
   ret
