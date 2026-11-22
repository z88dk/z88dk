
; double sinh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_sinh

EXTERN am48_exp, am48_dpopret, am48_dconst_1
EXTERN am48_dadd, am48_derror_znc, am48_ddiv

am48_sinh:

   ; hyperbolic sine
   ; AC' = sinh(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = sinh(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; sinh(x) = (exp(x) - exp(-x))/2

   push bc                     ; save AC
   push de
   push hl
   
   call am48_exp
   
   jp c, am48_dpopret
   
   call am48_dconst_1
   set 7,b
   
   exx
   
   call am48_ddiv

   jp c, am48_dpopret
   
   ; AC' = -exp(-x)
   ; AC  = exp(x)
   
   call am48_dadd
   
   exx
   ld a,l
   dec l                       ; divide by two
   exx
   
   pop hl                      ; restore AC
   pop de
   pop bc
   
   cp 2
   ret nc

   jp am48_derror_znc
