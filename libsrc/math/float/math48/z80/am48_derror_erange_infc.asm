
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_derror_erange_infc, am48_derror_erange_pinfc
PUBLIC am48_derror_erange_minfc, am48_derror_erange_infxc

EXTERN error_erange_zc, am48_dconst_inf

am48_derror_erange_pinfc:

   exx
   res 7,b
   exx
   
am48_derror_erange_infc:

   ; set AC' = +-inf depending on sign

   exx
   
   call error_erange_zc
   call am48_dconst_inf
   
   exx
   ret

am48_derror_erange_minfc:

   exx
   set 7,b
   exx
   
   jr am48_derror_erange_infc

   exx

am48_derror_erange_infxc:

   ; Set AC' = +-inf depending on xor of sign bits

   ld a,b
   
   exx
   xor b
   ld b,a
   exx
   
   jr am48_derror_erange_infc
