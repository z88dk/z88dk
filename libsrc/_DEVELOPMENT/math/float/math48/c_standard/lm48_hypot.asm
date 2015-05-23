
; double hypot(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_hypot

EXTERN lm48_fabs, mm48_equal, mm48_fpmul, mm48_fpadd, mm48_sqr

lm48_hypot:

   ; compute hypotenuse sqrt(x^2+y^2)
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = sqrt(x^2+y^2)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ; zero has special encoding

   ld a,l
   or a
   jp z, lm48_fabs             ; if x == 0 return |y|
   
   exx
   
   ld a,l
   or a
   jp z, lm48_fabs             ; if y == 0 return |x|

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

   cp 20
   jp nc, lm48_fabs            ; if |y| << |x| return |x|

   push bc                     ; save y
   push de
   push hl
   
   exx

   call mm48_equal
   call mm48_fpmul             ; AC'= x^2

   pop hl                      ; AC = y
   pop de
   pop bc
   
   ret c                       ; if overflow
   
   exx
   
   push bc                     ; save x^2
   push de
   push hl
   
   exx
   
   call mm48_equal
   call mm48_fpmul             ; AC'= y^2
   
   pop hl                      ; AC = x^2
   pop de
   pop bc

   call mm48_fpadd             ; AC = x^2 + y^2
   ret c                       ; if overflow
   
   jp mm48_sqr
