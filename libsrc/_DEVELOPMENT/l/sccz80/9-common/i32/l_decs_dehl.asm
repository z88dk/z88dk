
SECTION code_clib
SECTION code_l

PUBLIC l_decs_dehl

l_decs_dehl:

   ; signed decrement of long
   ;
   ; enter : dehl = signed long
   ;
   ; exit  : dehl = dehl - 1, min at $8000 0000
   ;         z flag set on underflow
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

   ld a,d
   cp $80
   ret z

   dec hl
   dec de
   ret
