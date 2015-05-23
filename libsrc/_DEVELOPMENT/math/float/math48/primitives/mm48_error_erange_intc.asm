
SECTION code_fp_math48

PUBLIC mm48_error_erange_intc

EXTERN error_erange_zc

   ex af,af'

mm48_error_erange_intc:

   ; integer result is out of range so return INT_MIN or INT_MAX
   ; z flag set if float was positive
   
   call error_erange_zc
   
   ld h,$80
   ret nz                      ; if negative
   
   dec hl
   ret
