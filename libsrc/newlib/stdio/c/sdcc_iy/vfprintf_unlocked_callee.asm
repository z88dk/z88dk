
; int vfprintf_unlocked_callee(FILE *stream, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vfprintf_unlocked_callee

EXTERN asm_vfprintf_unlocked

_vfprintf_unlocked_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af
   
   jp asm_vfprintf_unlocked
