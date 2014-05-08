; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

PUBLIC _sp1_PrintString

_sp1_PrintString:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   push ix
   
   call asm_sp1_PrintString
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_PrintString.asm"
