
PUBLIC error_erange_mc

EXTERN __ERANGE

EXTERN errno_mc

   pop hl
   
error_erange_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ERANGE

   ld hl,__ERANGE
   jp errno_mc
