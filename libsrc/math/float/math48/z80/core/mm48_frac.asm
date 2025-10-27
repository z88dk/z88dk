
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_frac

EXTERN mm48_equal, mm48_int, mm48_fpsub, mm48__add10

mm48_frac:

   ; floating point fraction part
   ; AC' = fraction_part(AC')
   ;
   ; AC' is set to the fraction part of AC' with the same sign as AC'.
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : AC'(BCDEHL') = fraction_part(x)
   ;
   ; note  : FRAC( 3.7)= 0.7
   ;         FRAC(-3.7)=-0.7
   ;
   ; uses  : af, af', bc', de', hl'

   push bc                     ; save AC
   push de
   push hl

   exx
   
   ; AC = x
   
   call mm48_equal
   call mm48_int               ; AC' = integer_part(AC')

   exx

   ; AC = integer_part(x)
   ; AC'= x

   call mm48_fpsub             ; AC' = fraction_part
   jp mm48__add10 + 1          ; restore AC
