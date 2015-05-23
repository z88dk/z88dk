
; double exp2(double x)

SECTION code_fp_math48

PUBLIC lm48_exp2

EXTERN mm48_exp, mm48__acln2, mm48_fpmul, mm48__add10

lm48_exp2:

   ; compute 2^x
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = 2^x
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; 2^x = exp(x*ln2)
   
   push bc                     ; save AC
   push de
   push hl
   
   call mm48__acln2            ; AC = ln(2)
   
   call mm48_fpmul
   call mm48_exp
   
   jp mm48__add10 + 1
