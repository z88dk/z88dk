
SECTION code_fp_math48

PUBLIC lm48__mul10

EXTERN mm48_mul10

   ; AC' = |AC'| * 10
   ;
   ; enter : EXX = float x
   ;
   ; exit  : success
   ;
   ;            AC'= abs(AC') * 10
   ;            carrry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= double_max
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

defc lm48__mul10 = mm48_mul10
