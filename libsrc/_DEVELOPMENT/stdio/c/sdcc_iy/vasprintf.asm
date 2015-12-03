
; int vasprintf(char **ptr, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vasprintf

EXTERN asm_vasprintf

_vasprintf:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   
   push bc
   push de
   push de
   push af
   
   jp asm_vasprintf
