
XLIB l_decs_dehl

l_decs_dehl:

   ; signed decrement of long
   ;
   ; enter : dehl = signed long
   ;
   ; exit  : dehl = dehl - 1, min at $8000 0000
   ;
   ; uses  : af, de, hl

   ld a,h
   or l
   or e
   
   jp nz, l_dec_dehl
   
   ld a,d
   cp $80
   jp nz, l_dec_dehl
   
   ret
