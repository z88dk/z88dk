
; int vfscanf_unlocked_callee(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfscanf_unlocked_callee

EXTERN asm_vfscanf_unlocked

_vfscanf_unlocked_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af
   
   jp asm_vfscanf_unlocked
