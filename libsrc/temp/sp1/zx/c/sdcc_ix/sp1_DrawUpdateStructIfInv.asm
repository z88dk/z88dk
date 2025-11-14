
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfInv

EXTERN _sp1_DrawUpdateStructIfInv_fastcall

_sp1_DrawUpdateStructIfInv:

   pop af
   pop hl
   
   push hl
   push af

   jp _sp1_DrawUpdateStructIfInv_fastcall
