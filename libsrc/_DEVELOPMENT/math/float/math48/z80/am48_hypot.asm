
; double hypot(double x, double y)

SECTION code_fp_math48

PUBLIC am48_hypot

EXTERN am48_fabs, am48_dequate, am48_dmul, am48_dadd, am48_sqrt

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

   ; zero has special encoding

   ld a,l
   or a
   jp z, am48_fabs             ; if x == 0 return |y|
   
   exx
   
   ld a,l
   or a
   jp z, am48_fabs             ; if y == 0 return |x|

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
   jp nc, am48_fabs            ; if |y| << |x| return |x|

   push bc                     ; save y
   push de
   push hl
   
   exx

   call am48_dequate
   call am48_dmul              ; AC'= x^2

   pop hl                      ; AC = y
   pop de
   pop bc
   
   ret c                       ; if overflow
   
   exx
   
   push bc                     ; save x^2
   push de
   push hl
   
   exx
   
   call am48_dequate
   call am48_dmul              ; AC'= y^2
   
   pop hl                      ; AC = x^2
   pop de
   pop bc

   call am48_dadd              ; AC = x^2 + y^2
   ret c                       ; if overflow
   
   jp am48_sqrt
