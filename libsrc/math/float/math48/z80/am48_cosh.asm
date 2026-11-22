
; double cosh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_cosh

EXTERN am48_exp, am48_dpopret, am48_dconst_1
EXTERN am48_ddiv, am48_dadd, am48_dxpopret

am48_cosh:

   ; hyperbolic cosine
   ; AC' = cosh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = cosh(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; cosh(x) = (exp(x) + exp(-x))/2

   push bc                     ; save AC
   push de
   push hl
   
   call am48_exp
   
   jp c, am48_dpopret
   
   call am48_dconst_1
   exx
   call am48_ddiv

   jp c, am48_dpopret
   
   ; AC' = exp(-x)
   ; AC  = exp(x)
   
   call am48_dadd
   
   jp c, am48_dpopret
   
   exx
   dec l                       ; divide by two
   
   jp am48_dxpopret
