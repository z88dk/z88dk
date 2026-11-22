
; double acos(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_acos

EXTERN am48_asin, am48_dconst_pi, am48_dsub, am48_dpopret

am48_acos:

   ; arccos
   ; AC' = acos(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = acos(x)
   ;            carry reset
   ;
   ;         fail if domain error |x| > 1
   ;
   ;            AC' = 0 or pi
   ;            carry set, errno set
   ;
   ; note  : 0 < acos(x) < pi
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; acos(x) = pi/2 - asin(x)
   
   call am48_asin
   
   push bc                     ; save AC
   push de
   push hl

   push af                     ; save error indicator

   call am48_dconst_pi
   dec l                       ; AC = pi/2
   
   exx
   
   call am48_dsub
   
   pop af                      ; restore error indicator
   jp am48_dpopret
