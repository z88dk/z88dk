
SECTION code_fp_math48

PUBLIC mm48_error_erange_infxc

EXTERN mm48_error_erange_infc

   exx

mm48_error_erange_infxc:

   ; Set AC' = +- infinity depending on xor of sign bits

   ld a,b
   
   exx
   xor b
   ld b,a
   exx
   
   jp mm48_error_erange_infc
