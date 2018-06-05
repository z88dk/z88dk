; void dostm_from_tm(struct dos_tm *,struct tm *)

SECTION code_time

PUBLIC dostm_from_tm_callee

EXTERN asm_dostm_from_tm

dostm_from_tm_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dostm_from_tm
