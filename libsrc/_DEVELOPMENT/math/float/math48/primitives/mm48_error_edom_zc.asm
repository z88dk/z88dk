
SECTION code_fp_math48

PUBLIC mm48_error_edom_zc

EXTERN error_edom_zc, mm48__zero

mm48_error_edom_zc:

   ; Set AC'=0, set carry
   
   exx

   call mm48__zero   
   call error_edom_zc

   exx
   ret
