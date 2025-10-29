; void tm_from_dostm(struct tm *,struct dos_tm *)

SECTION code_time

PUBLIC _tm_from_dostm_callee

EXTERN asm_tm_from_dostm

_tm_from_dostm_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_tm_from_dostm
