
; double asin(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_asin

EXTERN am48_dequate, am48_dmul, am48_dconst_1, am48_dsub
EXTERN am48_sqrt, am48_ddiv, am48_atan, am48_dpopret, am48_dconst_pi

am48_asin:

   ; arcsin
   ; AC' = asin(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = asin(x)
   ;            carry reset
   ;
   ;         fail if domain error |x| > 1
   ;
   ;            AC' = +-pi/2
   ;            carry set, errno set
   ;
   ; note  : -pi/2 < asin(x) < pi/2
   ;
   ; uses  : af, af', bc', de', hl'
   
   ; asin(x) = atan(x/sqrt(1-x*x))
   
   push bc                     ; save AC
   push de
   push hl
   
   exx
   
   push bc                     ; save x
   push de
   push hl
   
   call am48_dequate           ; AC = AC'= x
   call am48_dmul              ; AC'= x*x
   call am48_dconst_1          ; AC = 1
   
   exx
   
   call am48_dsub              ; AC'= 1-x*x
   call am48_sqrt
   
   pop hl                      ; AC = x
   pop de
   pop bc
   
   jr c, domain_err
   
   exx
   
   call am48_ddiv              ; AC'= x/sqrt(1-x*x)
   call am48_atan
   
   jp am48_dpopret

domain_err:

   ; AC = x
   
   ld a,b
   and $80                     ; a = sgn(x)
   
   call am48_dconst_pi
   dec l
   
   or b
   ld b,a                      ; AC = sgn(x)*pi/2
   
   exx
   
   scf
   jp am48_dpopret
