
; double acosh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_acosh

EXTERN am48_dpush, am48_dconst_1, am48_dsub, am48_sqrt
EXTERN am48_dadd, am48_dmul_s, am48_dadd_s, am48_log, am48_dpopret

am48_acosh:

   ; inverse hyperbolic cosine
   ; AC' = acosh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = acosh(x)
   ;            carry reset
   ;
   ;         fail if domain error (x < 1)
   ;
   ;            AC' = 0
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; acosh(x) = ln(x+sqrt(x-1)*sqrt(x+1))
   
   push bc                     ; save AC
   push de
   push hl
   
   call am48_dpush             ; push x
   
   call am48_dconst_1
   call am48_dsub
   call am48_sqrt              ; AC'= sqrt(x-1)
   
   pop hl
   pop de
   pop bc                      ; AC = x
   
   jp c, am48_dpopret          ; if x < 1
   
   push bc                     ; push x
   push de
   push hl
   
   exx                         ; AC'= x
   
   push bc                     ; save sqrt(x-1)
   push de
   push hl
   
   call am48_dconst_1
   call am48_dadd
   call am48_sqrt              ; AC'= sqrt(x+1)
   
   call am48_dmul_s            ; AC'= sqrt(x+1)*sqrt(x-1)
   call am48_dadd_s            ; AC'= x+sqrt(x+1)*sqrt(x-1)
   
   pop hl
   pop de
   pop bc                      ; restore original AC
   
   jp nc, am48_log             ; AC'= ln(AC')
   ret
