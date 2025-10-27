
; sp1_UpdateNow

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_UpdateNow

EXTERN asm_sp1_UpdateNow

_sp1_UpdateNow:

   push ix
   
   call asm_sp1_UpdateNow
   
   pop ix
   ret
