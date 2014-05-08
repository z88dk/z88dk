
PUBLIC error_edom_zc

EXTERN __EDOM

EXTERN errno_zc

   pop hl
   
error_edom_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=EDOM

   ld hl,__EDOM
   jp errno_zc
