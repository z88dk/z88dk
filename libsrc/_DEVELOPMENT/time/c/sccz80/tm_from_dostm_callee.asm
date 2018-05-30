; void tm_from_dostm(struct tm *,struct dos_tm *)

SECTION code_time

PUBLIC tm_from_dostm_callee

EXTERN asm_tm_from_dostm

tm_from_dostm_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_tm_from_dostm
