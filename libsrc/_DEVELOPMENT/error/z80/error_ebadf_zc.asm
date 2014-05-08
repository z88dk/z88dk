
PUBLIC error_ebadf_zc

EXTERN __EBADF

EXTERN errno_zc

   pop hl
   pop hl
   
error_ebadf_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=EBADF

   ld hl,__EBADF
   jp errno_zc
