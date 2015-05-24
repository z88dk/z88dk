
; double acos(double x)

SECTION code_fp_math48

PUBLIC lm48_acos

EXTERN lm48_asin, mm48__acpi, mm48_fpsub, mm48__add10

lm48_acos:

   ; arccos
   ; AC' = acos(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = acos(x)
   ;            carry reset
   ;
   ;         fail if domain error |x| > 1
   ;
   ;            AC' = 0
   ;            carry set, errno set
   ;
   ; note  : -pi/2 < acos(x) < pi/2
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; acos(x) = pi/2 - asin(x)
   
   call lm48_asin
   ret c                       ; if domain error
   
   push bc                     ; save AC
   push de
   push hl
   
   call mm48__acpi
   dec l                       ; AC = pi/2
   
   exx
   
   call mm48_fpsub
   jp mm48__add10 + 1
