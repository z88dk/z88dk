
; sp1_UpdateNow

PUBLIC _sp1_UpdateNow

_sp1_UpdateNow:

   push ix
   
   call asm_sp1_UpdateNow
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_UpdateNow.asm"
