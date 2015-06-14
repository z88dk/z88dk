
SECTION code_fp_math48

PUBLIC lm48__dhexpop

EXTERN mm48__left, mm48__retzero

lm48__dhexpop:

   exx
   
   pop af

   pop hl
   pop de
   pop bc
   
   push af
   
   ld a,b
   or a
   jp z, mm48__retzero
   
   ld a,$80

normalize:

   bit 7,b
   jr nz, normalize_done

   rl l
   call mm48__left
   
   dec a
   jr normalize

normalize_done:
   
   ld l,a
   res 7,b
   
   exx
   ret
