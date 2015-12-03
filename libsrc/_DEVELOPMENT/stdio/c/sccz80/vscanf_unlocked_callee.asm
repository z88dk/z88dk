
; int vscanf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vscanf_unlocked_callee

EXTERN asm_vscanf_unlocked

vscanf_unlocked_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_vscanf_unlocked
