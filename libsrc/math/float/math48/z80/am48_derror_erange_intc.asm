
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_erange_intc

EXTERN error_erange_zc

am48_derror_erange_intc:

   ; return INT_MAX or INT_MIN
   
   call error_erange_zc
   
   ld h,$80
   
   bit 7,b
   ret nz                      ; if negative
   
   dec hl
   ret
