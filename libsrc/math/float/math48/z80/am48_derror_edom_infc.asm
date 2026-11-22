
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_edom_infc, am48_derror_edom_pinfc, am48_derror_edom_minfc

EXTERN error_edom_zc, am48_dconst_inf

am48_derror_edom_pinfc:

   exx
   res 7,b
   exx
   
am48_derror_edom_infc:

   ; set AC' = +-inf depending on sign

   exx
   
   call error_edom_zc
   call am48_dconst_inf
   
   exx
   ret

am48_derror_edom_minfc:

   exx
   set 7,b
   exx
   
   jr am48_derror_edom_infc
