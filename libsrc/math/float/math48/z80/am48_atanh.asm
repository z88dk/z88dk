
; double atanh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_atanh

EXTERN am48_derror_edom_infc, am48_dconst_1, am48_dadd
EXTERN am48_log, am48_dpush, am48_dsub, am48_dpop, am48_dxpopret

am48_atanh:

   ; inverse hyperbolic tangent
   ; AC' = atanh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = atanh(x)
   ;            carry reset
   ;
   ;         fail if domain error (|x| > 1)
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; atanh(x) = 0.5*(ln(1+x)-ln(1-x))
   
   exx
   
   ld a,l
   cp $80 + 1
   
   exx
   
   jp nc, am48_derror_edom_infc  ; if |x| >= 1
   
   push bc                     ; save AC
   push de
   push hl
   
   call am48_dconst_1
   
   exx
   
   ; AC = x
   ; AC'= 1
   
   call am48_dadd
   call am48_log
   call am48_dpush             ; push ln(1+x)
   
   exx
   call am48_dconst_1
   exx
   
   call am48_dsub
   call am48_log
   
   exx
   
   call am48_dpop
   
   ; AC'= ln(1+x)
   ; AC = ln(1-x)
   
   call am48_dsub              ; AC'= ln(1+x)-ln(1-x)
   
   exx
   
   ld a,l
   or a
   jp z, am48_dxpopret         ; if AC' == 0
   
   dec l                       ; divide by two
   jp am48_dxpopret            ; restore AC
