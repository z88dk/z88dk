
; int vsprintf(char *s, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsprintf

EXTERN l0_vsprintf_callee

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
   
   jp l0_vsprintf_callee
