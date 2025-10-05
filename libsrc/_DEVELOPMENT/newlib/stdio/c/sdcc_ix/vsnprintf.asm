
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsnprintf

EXTERN l0_vsnprintf_callee

_vsnprintf:

   pop af
   exx
   pop de
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   push bc
   push de
   push af

   jp l0_vsnprintf_callee
