
; double cbrt(double x)

SECTION code_fp_math48

PUBLIC lm48_cbrt

EXTERN mm48__ac1_3, mm48_pwr, mm48__add10, mm48__zero

lm48_cbrt:

   ; compute the real cube root of x
   ;
   ; enter : AC'(BCDEHL) = double x
   ;
   ; exit  : AC'(BCDEHL) = x^(1/3)
   ;
   ; uses  : af, af', bc', de', hl'

   exx
   
   ld a,b
   res 7,b                     ; x = abs(x)
   
   inc l
   dec l
   
   exx
   ret z                       ; cbrt(0) = 0
   
   push bc                     ; save AC
   push de
   push hl

   and $80
   push af                     ; save sgn(x)

   call mm48__ac1_3            ; AC = 1/3
   call mm48_pwr               ; AC'= x^(1/3)
   
   pop af                      ; a = sgn(x)
   exx
   
   or b
   ld b,a                      ; result same sign as x
   
   jp mm48__add10
