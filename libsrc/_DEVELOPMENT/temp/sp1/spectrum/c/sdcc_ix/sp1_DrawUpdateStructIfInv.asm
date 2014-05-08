
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

PUBLIC _sp1_DrawUpdateStructIfInv

_sp1_DrawUpdateStructIfInv:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_sp1_DrawUpdateStructIfInv
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_DrawUpdateStructIfInv.asm"
