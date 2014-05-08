
PUBLIC error_erange_zc

EXTERN __ERANGE

EXTERN errno_zc

   pop hl
   
error_erange_zc:

   ; set hl = 0
   ; set carry flag
   ; set errno=ERANGE
   
   ld hl,__ERANGE
   jp errno_zc
