
; double cbrt(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_cbrt

EXTERN am48_dconst_1_3, am48_pow, am48_dxpopret

am48_cbrt:

   ; compute the real cube root of AC'
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = x^(1/3)
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

   call am48_dconst_1_3        ; AC = 1/3
   call am48_pow               ; AC'= |x|^(1/3)
   
   pop af                      ; a = sgn(x)
   exx
   
   or b
   ld b,a                      ; result same sign as x
   
   jp am48_dxpopret
