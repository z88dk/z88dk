
PUBLIC error_enolck_zc

EXTERN __ENOLCK

EXTERN errno_zc

   pop hl
   pop hl

error_enolck_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOLCK

   ld hl,__ENOLCK
   jp errno_zc
