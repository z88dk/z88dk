
SECTION code_fp_math48

PUBLIC lm48__dhexpop

EXTERN mm48__sleft, mm48__retzero

lm48__dhexpop:

   exx
   
   pop af
   
   dec sp

   pop hl
   pop de
   pop bc
   
   push af
   
   ld a,b
   or c
   or d
   or e
   or h
   jp z, mm48__retzero
   
   ld l,$80

normalize:

   bit 7,b
   jr nz, normalize_done

   call mm48__sleft
   
   dec l
   jr normalize

normalize_done:
   
   res 7,b
   
   exx
   ret
