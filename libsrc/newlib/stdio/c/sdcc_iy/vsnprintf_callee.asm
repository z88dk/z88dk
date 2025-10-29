
; int vsnprintf_callee(char *s, size_t n, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsnprintf_callee

EXTERN asm_vsnprintf

_vsnprintf_callee:

   pop af
   exx
   pop de
   pop bc
   exx
   pop de
   pop bc
   push af
   
   jp asm_vsnprintf
