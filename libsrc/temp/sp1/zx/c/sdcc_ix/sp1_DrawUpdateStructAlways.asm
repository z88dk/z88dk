
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructAlways

EXTERN _sp1_DrawUpdateStructAlways_fastcall

_sp1_DrawUpdateStructAlways:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _sp1_DrawUpdateStructAlways_fastcall
