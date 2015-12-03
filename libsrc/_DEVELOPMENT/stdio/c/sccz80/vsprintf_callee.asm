
; int vsprintf(char *s, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vsprintf_callee

EXTERN asm_vsprintf

vsprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   jp asm_vsprintf
