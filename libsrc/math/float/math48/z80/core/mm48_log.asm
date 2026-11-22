
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_log

EXTERN mm48_ln, mm48_fpmul, mm48__add10

mm48_log:

   ; base 10 logarithm
   ; AC' = log(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC'= log(x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'= double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

;LOG(X) beregnes af LN(X)/LN(10).

   call mm48_ln
   ret c

   push bc                     ;save AC
   push de
   push hl
   
   ld bc,$5E5B                 ;1/LN(10)
   ld de,$D8A9
   ld hl,$367F
   
   call mm48_fpmul
   jp mm48__add10 + 1
