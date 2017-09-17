
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

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtok_callee
defc _strtok_callee = strtok_callee
ENDIF

