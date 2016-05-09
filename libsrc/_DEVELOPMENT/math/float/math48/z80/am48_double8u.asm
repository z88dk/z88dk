
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double8u, am48_double8u_0

EXTERN am48_derror_znc

am48_double8u:

   ; 8-bit unsigned integer to double
   ;
   ; enter :  L = 8-bit unsigned integer n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld a,l
   or a
   jp z, am48_derror_znc + 1

am48_double8u_0:

   ld hl,$80 + 8
   
   jp m, normalized
   
normalize_loop:

   dec l
   
   add a,a
   jp p, normalize_loop

normalized:

   ld b,a
   ld c,h
   ld d,h
   ld e,h
   
   res 7,b
   
   exx
   ret
