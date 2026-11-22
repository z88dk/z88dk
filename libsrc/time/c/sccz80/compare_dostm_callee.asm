; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

SECTION code_time

PUBLIC compare_dostm_callee

EXTERN asm_compare_dostm

compare_dostm_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_compare_dostm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _compare_dostm_callee
defc _compare_dostm_callee = compare_dostm_callee
ENDIF

