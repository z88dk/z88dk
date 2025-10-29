
; int vsprintf(char *s, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsprintf

EXTERN asm_vsprintf

_vsprintf:

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
   
   jp asm_vsprintf
