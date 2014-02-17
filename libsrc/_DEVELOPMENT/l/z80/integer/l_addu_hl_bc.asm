
XLIB l_addu_hl_bc

l_addu_hl_bc:

   ; uses : hl, f
   ; carry set on overflow
   
   add hl,bc
   ret nc
   
   ld hl,$ffff
   ret
