
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double16u

EXTERN am48_double8u

am48_double16u:

   ; 16-bit unsigned integer to double
   ;
   ; enter : HL = 16-bit unsigned integer n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld a,h
   or a
   jp z, am48_double8u
   
   ld de,$80 + 16              ; e = exponent

   bit 7,h
   jr nz, normalized
   
normalize_loop:

   dec e
   
   add hl,hl
   jp p, normalize_loop

normalized:

   ld b,h
   ld c,l

   ex de,hl
   
   ld d,h
   ld e,h
   
   res 7,b                     ; bcdehl = (float)(n)

   exx
   ret
