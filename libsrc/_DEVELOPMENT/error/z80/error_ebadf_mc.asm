
PUBLIC error_ebadf_mc

EXTERN __EBADF

EXTERN errno_mc

   pop hl
   
error_ebadf_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EBADF

   ld hl,__EBADF
   jp errno_mc
