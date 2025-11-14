
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_znc

EXTERN am48_dconst_0

am48_derror_znc:

   ; exit : AC'= 0
   ;        carry reset
   ;
   ; uses : af, bc', de', hl'
   
   exx
   call am48_dconst_0
   exx
   
   scf
   ccf
   ret
