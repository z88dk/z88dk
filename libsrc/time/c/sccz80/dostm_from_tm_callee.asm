; void dostm_from_tm(struct dos_tm *,struct tm *)

SECTION code_time

PUBLIC dostm_from_tm_callee

EXTERN asm_dostm_from_tm

dostm_from_tm_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dostm_from_tm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dostm_from_tm_callee
defc _dostm_from_tm_callee = dostm_from_tm_callee
ENDIF

