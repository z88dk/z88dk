
SECTION code_fp_math48

PUBLIC mm48_error_edom_infc, mm48_error_edom_pinfc, mm48_error_edom_minfc

EXTERN error_edom_zc, mm48__acinfc

mm48_error_edom_pinfc:

   exx
   res 7,b
   exx
   
mm48_error_edom_infc:

   ; set AC' = +- infinity depending on its sign

   exx
   
   call error_edom_zc
   call mm48__acinfc
   
   exx
   ret

mm48_error_edom_minfc:

   exx
   set 7,b
   exx
   
   jr mm48_error_edom_infc
