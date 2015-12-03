
; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strtok_callee

EXTERN asm_strtok

strtok_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strtok
