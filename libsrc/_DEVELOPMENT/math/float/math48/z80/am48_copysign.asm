
; double copysign(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_copysign

am48_copysign:

   ; Make sign of AC' the same as sign of AC
   ;
   ; enter : AC' = double x
   ;         AC  = double y
   ;
   ; exit  : AC' = abs(x) * sgn(y)
   ;
   ; uses  : af, b'

   ld a,l
   or a
   jr z, zero                  ; sgn(0) is positive
   
   ld a,b
   and $80                     ; a = sgn(y)

zero:

   exx
   res 7,b
   or b
   ld b,a
   exx
   
   ret
