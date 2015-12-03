
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_onc

EXTERN am48_dconst_1

am48_derror_onc:

   ; exit : AC'= 1
   ;        carry reset
   ;
   ; uses : af, bc', de', hl'
   
   exx
   call am48_dconst_1
   exx
   
   scf
   ccf
   ret
