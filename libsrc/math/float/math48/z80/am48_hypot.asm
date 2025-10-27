
; double hypot(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_hypot

EXTERN am48_fabs, am48_dequate, am48_dmul, am48_dadd, am48_sqrt
EXTERN am48_dconst_1, am48_ddiv

am48_hypot:

   ; compute hypotenuse sqrt(x^2+y^2)
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : success
   ;
   ;            AC' = sqrt(x^2+y^2)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ld a,l
   or a
   jp z, am48_fabs             ; if x == 0 return |y|
   
   res 7,b                     ; x = |x|
      
   exx
   
   ld a,l
   or a
   ret z                       ; if y == 0 return |x|

   res 7,b                     ; y = |y|

   ; compare magnitudes
   
   exx
   
   sub l                       ; a = exponent difference
   jp p, cmp_mag               ; if AC' has larger magnitude
   neg
   
   exx

cmp_mag:

   ; AC'= largest magnitude x
   ; AC = y
   ;  a = |exp diff|

   cp 21
   ret nc                      ; if |y| << |x| return |x|

   exx

   ; AC = largest magnitude x
   ; AC'= y

   ; sqrt(x*x+y*y) = x*sqrt(y*y/(x*x)+1)

   call am48_ddiv              ; AC'= y/x
   
   push bc
   push de
   push hl                     ; push x
   
   exx
   
   call am48_dequate           ; AC = AC'= y/x
   call am48_dmul              ; AC'= (y/x)*(y/x)
   call am48_dconst_1          ; AC = 1
   call am48_dadd              ; AC'= y*y/(x*x)+1
   call am48_sqrt              ; AC'= sqrt(...)
   
   pop hl
   pop de
   pop bc                      ; AC = x

   jp am48_dmul
