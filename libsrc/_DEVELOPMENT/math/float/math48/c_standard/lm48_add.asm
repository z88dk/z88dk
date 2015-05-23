
SECTION code_fp_math48

PUBLIC lm48_add

EXTERN mm48_fpadd

   ; floating point add
   ; AC' = AC' + AC
   ;
   ; enter : AC (BCDEHL ) = float a
   ;         AC'(BCDEHL') = float b
   ;
   ; exit  : AC (BCDEHL ) unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = a + b
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_add = mm48_fpadd
