; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PrintString_callee, l0_sp1_PrintString_callee

EXTERN asm_sp1_PrintString

_sp1_PrintString_callee:

   pop af
   pop hl
   pop de
   push af

l0_sp1_PrintString_callee:

   push ix
   
   call asm_sp1_PrintString
   
   pop ix
   ret
