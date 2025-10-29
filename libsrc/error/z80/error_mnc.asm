
SECTION code_clib
SECTION code_error

PUBLIC error_mnc

   pop hl
   pop hl
   pop hl

error_mnc:

   ; set hl = -1
   ; reset carry flag
   
   ld hl,-1
   
   scf
   ccf
   
   ret
