
PUBLIC error_enomem_zc

EXTERN __ENOMEM

EXTERN errno_zc

   pop hl
   pop hl
   pop hl
   
error_enomem_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOMEM

   ld hl,__ENOMEM
   jp errno_zc
