
SECTION code_clib
SECTION code_error

PUBLIC error_oc

   pop hl

error_oc:

   ; set hl = 1
   ; set carry flag
   
   ld hl,1
   scf
   
   ret
