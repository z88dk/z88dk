
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_einval_zc

EXTERN error_einval_zc, am48_dconst_0

am48_derror_einval_zc:

   ; set AC' = 0
   
   exx
   
   call error_einval_zc
   call am48_dconst_0
   
   exx
   ret
