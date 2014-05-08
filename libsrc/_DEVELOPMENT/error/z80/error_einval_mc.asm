
PUBLIC error_einval_mc

EXTERN __EINVAL

EXTERN errno_mc

   pop hl
   pop hl
   pop hl

error_einval_mc:

   ; set hl=0
   ; set carry flag
   ; set errno=EINVAL

   ld hl,__EINVAL
   jp errno_mc
