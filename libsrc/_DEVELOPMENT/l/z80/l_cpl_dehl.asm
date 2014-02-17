
XLIB l_cpl_dehl

l_cpl_dehl:

   ; uses : af, de, hl
   
   ld a,l
   cpl
   ld l,a
   
   ld a,h
   cpl
   ld h,a
   
   ld a,e
   cpl
   ld e,a
   
   ld a,d
   cpl
   ld d,a
   
   ret
