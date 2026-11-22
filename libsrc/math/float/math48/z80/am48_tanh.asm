
; double tanh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_tanh

EXTERN am48_dequate, am48_sinh, am48_cosh, am48_ddiv, am48_dpopret

am48_tanh:

   ; hyberbolic tangent
   ; AC' = tanh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = tanh(x)
   ;         carry reset
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; tanh(x) = sinh(x)/cosh(x)
   
   push bc                     ; save AC
   push de
   push hl
   
   exx
   
   call am48_dequate
   
   ; AC = AC' = x
   
   call am48_cosh
   exx
   call am48_sinh
   call am48_ddiv
   
   jp am48_dpopret
