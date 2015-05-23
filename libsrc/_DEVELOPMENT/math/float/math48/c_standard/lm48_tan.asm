
; double tan(double x)

SECTION code_fp_math48

PUBLIC lm48_tan

EXTERN mm48_tan

   ; compute tan(x)
   ;
   ; enter : AC'(BCDEHL') = double x in radians
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = tan(x)
   ;            carry reset
   ;
   ;         fail if cos(x)=0
   ;
   ;            AC'(BCDEHL') = double_min or double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_tan = mm48_tan
