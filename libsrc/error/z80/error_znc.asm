
SECTION code_clib
SECTION code_error

PUBLIC error_znc

   pop hl
   pop hl
   pop hl
   
error_znc:

   ; set hl = 0
   ; reset carry flag
   
   ld hl,0
   
   scf
   ccf
   
   ret
