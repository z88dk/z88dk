
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dhexpop

EXTERN mm48__left, am48_derror_znc

am48_dhexpop:

   ; strtod helper
   ;
   ; create double from mantissa on stack
   ; (one extra nibble on stack)
   ;
   ; enter : stack = mantissa, ret
   ;
   ; exit  : AC'= double
   ;
   ; uses  : af, bc', de', hl'

   exx
   
   pop af

   pop hl
   pop de
   pop bc
   
   push af
   
   ld a,b
   or a
   jp z, am48_derror_znc
   
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
