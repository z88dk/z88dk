
; int isless(real-floating x, real-floating y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_isless

EXTERN am48_dlt

   ; Return bool (AC < AC')
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : HL = 0 and carry reset if false
   ;         HL = 1 and carry set if true
   ;
   ; uses  : af, hl

defc am48_isless = am48_dlt
