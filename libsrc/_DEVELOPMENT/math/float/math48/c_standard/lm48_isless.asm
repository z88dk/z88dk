
; int isless(real-floating x, real-floating y)

SECTION code_fp_math48

PUBLIC lm48_isless

EXTERN mm48_cmp, error_mc, error_znc

lm48_isless:

   ; Return bool (x) < (y)
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : HL =  0 and carry reset if false
   ;         HL = -1 and carry set if true
   ;
   ; uses  : af, hl
   
   call mm48_cmp
   
   jp z, error_znc             ; if x == y false
   jp c, error_mc              ; if x < y true
   
   jp error_znc
