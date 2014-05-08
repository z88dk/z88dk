
PUBLIC error_enomem_mc

EXTERN __ENOMEM

EXTERN errno_mc

   pop hl
   pop hl
   pop hl
   
error_enomem_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ENOMEM

   ld hl,__ENOMEM
   jp errno_mc
