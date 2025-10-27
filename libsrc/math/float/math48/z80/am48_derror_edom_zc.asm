
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_edom_zc

EXTERN error_edom_zc, am48_dconst_0

am48_derror_edom_zc:

   ; set AC' = 0
   
   exx
   
   call error_edom_zc
   call am48_dconst_0
   
   exx
   ret
