
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double32u

EXTERN am48_double16u

am48_double32u:

   ; 32-bit unsigned long to double
   ;
   ; enter : DEHL = 32-bit unsigned long n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,d
   or e
   jp z, am48_double16u

coarse:
 
   inc d
   dec d
   jr nz, no_coarse

yes_coarse:

   ld b,e
   ld c,h
   ld h,l
   ld l,0
   
   ld de,$80 + 24
   jr fine

no_coarse:

   ld b,d
   ld c,e                      ; bchl = n
   
   ld de,$80 + 32              ; e = exponent

fine:

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
