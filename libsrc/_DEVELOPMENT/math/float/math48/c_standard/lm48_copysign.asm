
; double copysign(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_copysign

lm48_copysign:

   ; Make sign of x the same as sign of y
   ;
   ; enter : AC'(BCDEHL ) = double x
   ;         AC (BCDEHL') = double y
   ;
   ; exit  : AC'(BCDEHL)  = abs(x) * sgn(y)
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
