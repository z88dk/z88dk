
SECTION code_clib
SECTION code_l

PUBLIC l_dec_dehl

l_dec_dehl:

   ; decrement 32-bit value
   ;
   ; enter : dehl = 32 bit number
   ;
   ; exit  : dehl = dehl - 1
   ;
   ; uses  : af, de, hl
   
   ld a,h
   or l
   
   dec hl
   ret nz
   
   dec de
   ret
