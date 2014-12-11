; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

SECTION code_temp_sp1

PUBLIC _sp1_PrintString

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

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_PrintString.asm"
