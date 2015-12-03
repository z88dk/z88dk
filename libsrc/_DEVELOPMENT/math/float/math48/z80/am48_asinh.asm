
; double asinh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_asinh

EXTERN am48_dequate, am48_dmul, am48_dconst_1
EXTERN am48_dadd, am48_sqrt, am48_log

am48_asinh:

   ; inverse hyperbolic sine
   ; AC' = asinh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = asinh(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; asinh(x) = ln(x+sqrt(x*x+1))
   
   push bc                     ; save AC
   push de
   push hl
   
   exx
   
   call am48_dequate           ; AC = AC' = x  
   
   ld a,l
   cp $80 + 21
   
   jr nc, sqrt_done            ; if adding 1 to x*x has no effect
   
   push bc                     ; push x
   push de
   push hl
   
   call am48_dmul
   call am48_dconst_1
   call am48_dadd
   call am48_sqrt
   
   pop hl
   pop de
   pop bc

sqrt_done:

   ; AC = x
   ; AC'= sqrt(x*x+1)
   
   call am48_dadd
   
   pop hl                      ; restore original AC
   pop de
   pop bc
   
   jp nc, am48_log
   ret
