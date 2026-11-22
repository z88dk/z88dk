; void dostm_from_tm(struct dos_tm *,struct tm *)

SECTION code_time

PUBLIC _dostm_from_tm_callee

EXTERN asm_dostm_from_tm

_dostm_from_tm_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dostm_from_tm
