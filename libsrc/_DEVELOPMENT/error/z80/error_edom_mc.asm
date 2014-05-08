
PUBLIC error_edom_mc

EXTERN __EDOM

EXTERN errno_mc

   pop hl
   
error_edom_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EDOM

   ld hl,__EDOM
   jp errno_mc
