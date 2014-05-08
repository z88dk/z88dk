
PUBLIC error_enotsup_zc

EXTERN __ENOTSUP

EXTERN errno_zc

   pop hl
   
error_enotsup_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOTSUP

   ld hl,__ENOTSUP
   jp errno_zc
