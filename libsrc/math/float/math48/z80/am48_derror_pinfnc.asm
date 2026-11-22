
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_pinfnc

EXTERN am48_dconst_pinf

   pop hl
   pop hl

am48_derror_pinfnc:

   ; exit : AC'= +inf
   ;        carry reset
   ;
   ; uses : af, bc', de', hl'
   
   exx
   call am48_dconst_pinf
   exx
   
   scf
   ccf
   ret
