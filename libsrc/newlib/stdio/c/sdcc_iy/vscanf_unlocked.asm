
; int vscanf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vscanf_unlocked

EXTERN asm_vscanf_unlocked

_vscanf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_vscanf_unlocked
