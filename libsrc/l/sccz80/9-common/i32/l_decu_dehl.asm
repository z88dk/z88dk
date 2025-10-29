
SECTION code_clib
SECTION code_l

PUBLIC l_decu_dehl

l_decu_dehl:

   ; unsigned decrement of ulong
   ;
   ; enter : dehl = unsigned long
   ;
   ; exit  : dehl = dehl - 1, min at 0
   ;         z flag set underflow
   ;
   ; uses  : af, de, hl

   ld a,h
   or l
   jr z, msw
   
   dec hl
   ret

msw:

   or e
   jr z, limit
   
   dec hl
   dec de
   ret

limit:

   or d
   ret z
   
   dec hl
   dec de
   ret
