
; int vscanf_unlocked_callee(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vscanf_unlocked_callee

EXTERN asm_vscanf_unlocked

_vscanf_unlocked_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_vscanf_unlocked
