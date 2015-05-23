
SECTION code_fp_math48

PUBLIC lm48_sub

EXTERN mm48_fpsub

   ; compute x-y
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = y-x
   ;           carry reset
   ;
   ;         fail if overflow
   ;
   ;           AC'(BCDEHL') = double_min or double_max
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_sub = mm48_fpsub
