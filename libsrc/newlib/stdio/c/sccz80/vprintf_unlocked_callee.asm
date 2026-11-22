
; int vprintf_unlocked(const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vprintf_unlocked_callee

EXTERN asm_vprintf_unlocked

vprintf_unlocked_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_vprintf_unlocked
