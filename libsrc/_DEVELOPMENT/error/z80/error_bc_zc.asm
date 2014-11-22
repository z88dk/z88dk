
SECTION seg_code_error

PUBLIC error_bc_zc

error_bc_zc:

   ; set bc = 0
   ; set carry flag
   
   ld bc,0
   scf
   ret
