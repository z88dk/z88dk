
; int vasprintf(char **ptr, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vasprintf_callee

EXTERN asm_vasprintf

vasprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   jp asm_vasprintf
