
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_erange_longc

EXTERN error_erange_zc

am48_derror_erange_longc:

   ; return LONG_MIN or LONG_MAX
   
   call error_erange_zc
   
   ld e,l
   ld d,$80
   
   bit 7,b
   ret nz                      ; if negative
   
   dec de
   dec hl
   ret
