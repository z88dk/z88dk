
SECTION code_fp_math48

PUBLIC mm48_error_erange_infc, mm48_error_erange_pinfc, mm48_error_erange_minfc

EXTERN error_erange_zc, mm48__acinfc

mm48_error_erange_pinfc:

   exx
   res 7,b                     ; second entry point (label + 1)
   exx
   
mm48_error_erange_infc:

   ; set AC' = +- infinity depending on its sign

   exx
   
   call error_erange_zc        ; second entry point
   call mm48__acinfc
   
   exx
   ret

mm48_error_erange_minfc:

   exx
   set 7,b
   exx
   
   jr mm48_error_erange_infc
