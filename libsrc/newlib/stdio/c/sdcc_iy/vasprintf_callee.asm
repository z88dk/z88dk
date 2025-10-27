
; int vasprintf_callee(char **ptr, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vasprintf_callee

EXTERN asm_vasprintf

_vasprintf_callee:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   push af
   
   jp asm_vasprintf
