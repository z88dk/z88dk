
; int vprintf_unlocked_callee(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vprintf_unlocked_callee

EXTERN asm_vprintf_unlocked

_vprintf_unlocked_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_vprintf_unlocked
