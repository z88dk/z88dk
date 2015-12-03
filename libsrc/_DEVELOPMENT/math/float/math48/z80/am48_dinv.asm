
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dinv

EXTERN am48_dconst_1, am48_ddiv

am48_dinv:

   ; invert
   ; AC' = 1/AC'
   ;
   ; enter : AC'= double x
   ;
   ; exit  : AC = double x
   ;
   ;         success
   ;
   ;            AC' = 1/x
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-infinity
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call am48_dconst_1          ; AC = 1
   exx
   jp am48_ddiv
