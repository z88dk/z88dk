
; double expm1(double x)

SECTION code_fp_math48

PUBLIC lm48_expm1

EXTERN mm48__ac1, mm48_exp, mm48__add10, mm48_fpadd

lm48_expm1:

   ; compute exp(x)-1
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = exp(x) - 1
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   call mm48_exp
   ret c                       ; if overflow

   push bc                     ; save AC
   push de
   push hl
   
   call mm48__ac1
   set 7,b                     ; AC = -1

   call mm48_fpadd
   jp mm48__add10 + 1
