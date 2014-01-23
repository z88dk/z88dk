
XLIB l_saturated_inc_bc

l_saturated_inc_bc:

   ; uses : af, bc
   ; carry reset

   inc bc
   
   ld a,b
   or c
   ret nz
   
   ld bc,$ffff
   ret
