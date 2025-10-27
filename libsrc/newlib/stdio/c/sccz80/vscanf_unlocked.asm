
; int vscanf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vscanf_unlocked

EXTERN asm_vscanf_unlocked

vscanf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_vscanf_unlocked
