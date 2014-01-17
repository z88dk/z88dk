
XLIB l_saturated_add_hl_bc

l_saturated_add_hl_bc:

   ; uses : hl
   
   add hl,bc
   ret nc
   
   ld hl,$ffff
   ret
