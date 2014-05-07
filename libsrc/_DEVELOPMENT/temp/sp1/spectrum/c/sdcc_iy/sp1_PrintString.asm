; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

XDEF _sp1_PrintString

_sp1_PrintString:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   push iy
   
   call asm_sp1_PrintString
   
   pop iy
   ret

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_PrintString.asm"
