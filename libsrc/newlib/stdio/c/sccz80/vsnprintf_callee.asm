
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vsnprintf_callee

EXTERN asm_vsnprintf

vsnprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop bc
   pop de
   exx
   push af
   
   jp asm_vsnprintf
