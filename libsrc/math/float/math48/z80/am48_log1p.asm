
; double log1p(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_log1p

EXTERN am48_dconst_1, am48_dadd, am48_log, am48_dpopret

am48_log1p:

   ; compute ln(x+1)
   ; supposed to be more accurate than ln(x+1) for small |x| (not here)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = ln(x+1)
   ;            carry reset
   ;
   ;         fail on domain error
   ;
   ;            AC' = -inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   push bc                     ; save AC
   push de
   push hl
   
   call am48_dconst_1
   call am48_dadd
   call am48_log
   
   jp am48_dpopret
