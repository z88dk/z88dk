
SECTION code_clib
SECTION code_error

PUBLIC error_onc

   pop hl
   pop hl
   pop hl

error_onc:

   ; set hl = 1
   ; reset carry flag
   
   ld hl,1
   
   scf
   ccf
   
   ret
