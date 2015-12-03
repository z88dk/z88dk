
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double32u

EXTERN am48_derror_znc

am48_double32u:

   ; 32-bit unsigned long to double
   ;
   ; enter : DEHL = 32-bit unsigned long n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ld a,d
   or e
   or h
   or l
   jp z, am48_derror_znc + 1   ; if n == 0

   ld c,e
   ld b,d                      ; bchl = n
   
   ld de,$80 + 32              ; e = exponent

   bit 7,b
   jr nz, normalized

normalize_loop:

   dec e

   add hl,hl
   rl c
   rl b
   
   jp p, normalize_loop

normalized:

   res 7,b
   ex de,hl                    ; bcdehl = (float)(n)

   exx
   ret
