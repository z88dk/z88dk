
PUBLIC error_eoverflow_zc

EXTERN __EOVERFLOW

EXTERN errno_zc

   pop hl
   
error_eoverflow_zc:

   ; set hl = 0
   ; set carry flag
   ; set errno=EOVERFLOW
   
   ld hl,__EOVERFLOW
   jp errno_zc
