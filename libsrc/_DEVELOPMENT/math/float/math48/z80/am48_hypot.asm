
; double hypot(double x, double y)

SECTION code_fp_math48

PUBLIC am48_hypot

EXTERN am48_fabs, am48_dequate, am48_dmul, am48_dadd, am48_sqrt
EXTERN am48_dpopret, am48_dconst_1, am48_ddiv

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

   ; sqrt(x*x+y*y) = y*sqrt(x*x/(y*y)+1)

   call am48_ddiv              ; AC'= x/y
   ret c                       ; if overflow
   
   push bc
   push de
   push hl                     ; push y
   
   exx
   
   call am48_dequate           ; AC = AC'= x/y
   
   call am48_dmul              ; AC'= (x/y)*(x/y)
   jp c, am48_dpopret          ; if overflow

   call am48_dconst_1          ; AC = 1
   call am48_dadd              ; AC'= x*x/(y*y)+1
   call am48_sqrt              ; AC'= sqrt(...)
   
   pop hl
   pop de
   pop bc                      ; AC = y

   jp am48_dmul
