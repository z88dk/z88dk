
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_cos

EXTERN mm48__acpi, mm48_fpsub, mm48__sinc

mm48_cos:

   ; cosine
   ; AC' = cos(AC') = sin(pi/2 - AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : AC' = cos(x)
   ;
   ; uses  : af, af', bc', de', hl'

   push bc                     ; save AC
   push de
   push hl
   
   call mm48__acpi
   dec l                       ; AC = pi/2
   
   exx
   call mm48_fpsub             ; AC'= pi/2 - x
   jp mm48__sinc
