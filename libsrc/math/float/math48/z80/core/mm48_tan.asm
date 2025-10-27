
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_tan

EXTERN mm48_equal, mm48_cos, mm48_sin, mm48_fpdiv, mm48__add10

mm48_tan:

   ; tangent
   ; AC' = tan(AC') = sin(AC') / cos(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = tan(x)
   ;            carry reset
   ;
   ;         fail if overflow ie x = pi/2+n*pi
   ;
   ;            AC' = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   push bc                     ; save AC
   push de
   push hl
   
   exx
   
   call mm48_equal
   call mm48_cos
   
   exx
   
   call mm48_sin
   call mm48_fpdiv
   
   ; AC' = result
   
   jp mm48__add10 + 1
