
; double expm1(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_expm1

EXTERN am48_exp, am48_dconst_1, am48_dsub, am48_dpopret

am48_expm1:

   ; compute exp(AC')-1
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = exp(x) - 1
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   call am48_exp
   ret c                       ; if overflow

   push bc                     ; save AC
   push de
   push hl
   
   call am48_dconst_1
   call am48_dsub

   jp am48_dpopret
