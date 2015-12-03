
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double16u

EXTERN am48_derror_znc

am48_double16u:

   ; 16-bit unsigned integer to double
   ;
   ; enter : HL = 16-bit unsigned integer n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld a,h                      ;Er HL=0?
   or l
   jp z, am48_derror_znc + 1   ;Ja => ZERO
   
   ld de,$80 + 17              ; e = exponent

normalize_loop:

   dec e
   
   ld c,l
   ld b,h
   
   add hl,hl
   jr nc, normalize_loop
   
   ld l,d
   ld h,d
   
   res 7,b
   ex de,hl                    ; bcdehl = (float)(n)

   exx
   ret
