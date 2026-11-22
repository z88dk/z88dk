
SECTION code_clib
SECTION code_error

PUBLIC error_mc

   pop hl
   pop hl
   pop hl

error_mc:

   ; set hl = -1
   ; set carry flag
   
   ld hl,-1
   scf
   ret
