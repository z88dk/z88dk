
PUBLIC error_enotsup_mc

EXTERN __ENOTSUP

EXTERN errno_mc

   pop hl
   
error_enotsup_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ENOTSUP

   ld hl,__ENOTSUP
   jp errno_mc
