
; double exp2(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_exp2

EXTERN am48_dconst_ln2, am48_dmul, am48_exp, am48_dpopret

am48_exp2:

   ; compute 2^x
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = 2^x
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; 2^x = exp(x*ln2)
   
   push bc                     ; save AC
   push de
   push hl
   
   call am48_dconst_ln2        ; AC = ln(2)
   
   call am48_dmul
   call am48_exp
   
   jp am48_dpopret
