
; double atan(double x)

SECTION code_fp_math48

PUBLIC lm48_atan

EXTERN mm48_atn

   ; arctan
   ; AC' = atan(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : AC' = atan(x)
   ;
   ; note  : -pi/2 < atan(x) < pi/2
   ;
   ;         atan( 1 )= pi/4
   ;         atan(-1 )=-pi/4
   ;
   ; uses  : af, af', bc', de', hl'
   
defc lm48_atan = mm48_atn
