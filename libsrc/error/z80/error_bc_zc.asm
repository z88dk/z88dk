
SECTION code_clib
SECTION code_error

PUBLIC error_bc_zc

   pop bc

error_bc_zc:

   ; set bc = 0
   ; set carry flag
   
   ld bc,0
   scf
   ret
