
XLIB l_saturated_inc_hl

l_saturated_inc_hl:

   ; uses : af, hl
   ; carry reset

   inc hl
   
   ld a,h
   or l
   ret nz
   
   ld hl,$ffff
   ret

