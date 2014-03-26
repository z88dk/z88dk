
XLIB l_inc_dehl

l_inc_dehl:

   ; increment 32-bit value
   ;
   ; enter : dehl = 32 bit number
   ;
   ; exit  : dehl = dehl + 1
   ;
   ; uses  : af, de, hl
   
   inc hl
   
   ld a,h
   or l
   ret nz
   
   inc de
   ret
