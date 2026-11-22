
SECTION code_clib
SECTION code_error

PUBLIC error_zc

   pop hl
   pop hl
   pop hl
   pop hl

error_zc:

   ; set hl = 0
   ; set carry flag
   
   ld hl,0
   scf
   ret
