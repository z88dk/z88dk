
SECTION code_fp_math48

PUBLIC mm48_error_erange_longc

EXTERN error_erange_zc

   ex af,af'

mm48_error_erange_longc:

   ; long result is out of range so return LONG_MIN or LONG_MAX
   ; z flag set if float was positive
   
   call error_erange_zc
   
   ld e,l
   ld d,$80
   ret nz                      ; if negative
   
   dec de
   dec hl
   ret
