
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_erange_longlongc

EXTERN error_erange_zc, error_llmc, error_llzc

am48_derror_erange_longlongc:

   ; return LLONG_MIN or LLONG_MAX
 
   call error_erange_zc
 
   bit 7,b
   jr nz, negative
   
positive:

   call error_llmc
   ld d,$7f
   
   exx
   ret

negative:

   call error_llzc
   ld d,$80
   
   exx
   ret
