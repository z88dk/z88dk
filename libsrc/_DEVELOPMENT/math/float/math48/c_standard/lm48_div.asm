
SECTION code_fp_math48

PUBLIC lm48_div

EXTERN mm48_fpdiv

   ; compute y/x
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = y/x
   ;           carry reset
   ;
   ;         fail if divide by zero
   ;
   ;           AC'(BCDEHL') = double_min or double_max
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_div = mm48_fpdiv
