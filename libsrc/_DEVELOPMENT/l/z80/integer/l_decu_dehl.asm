
XLIB l_decu_dehl

l_decu_dehl:

   ; unsigned decrement of ulong
   ;
   ; enter : dehl = unsigned long
   ;
   ; exit  : dehl = dehl - 1, min at 0
   ;
   ; uses  : af, de, hl

   ld a,d
   or e
   or h
   or l
   
   jp nz, l_dec_dehl
   ret
