
SECTION code_fp_math48

PUBLIC mm48_ufloat

EXTERN mm48__retzero

mm48_ufloat:

   ; 16-bit unsigned integer to floating point number
   ;
   ; enter : HL = 16-bit unsigned integer n
   ;
   ; exit  : AC = AC' (exx set saved)
   ;         AC'= (float)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld a,h                      ;Er HL=0?
   or l
   jp z, mm48__retzero         ;Ja => ZERO
   
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
