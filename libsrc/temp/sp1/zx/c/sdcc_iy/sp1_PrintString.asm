; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PrintString

EXTERN l0_sp1_PrintString_callee

_sp1_PrintString:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_sp1_PrintString_callee
