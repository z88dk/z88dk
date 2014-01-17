
XLIB l_saturated_add_hl_de

l_saturated_add_hl_de:

   ; uses : hl
   
   add hl,de
   ret nc
   
   ld hl,$ffff
   ret
