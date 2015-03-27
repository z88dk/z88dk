
SECTION code_fp_math48

PUBLIC mm48_cos

EXTERN mm48_acpi, mm48_fpsub, mm48__sinc

mm48_cos:

;     Cosine
;     -------
;
;     NAME:      COS
;     FUNCTION:  AC=COS(AC) or AC=SIN(PI/2-AC). AC is set equal to
;                the cosine of AC.
;     OFFSET:    24H
;     STACK:     10 bytes.

   exx
   push bc
   push de
   push hl
   call mm48_acpi
   dec l
   call mm48_fpsub
   exx
   jp mm48__sinc
