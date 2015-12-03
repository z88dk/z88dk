
; int vsprintf_callee(char *s, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsprintf_callee, l0_vsprintf_callee

EXTERN asm_vsprintf

_vsprintf_callee:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   push af

l0_vsprintf_callee:

   push ix
   
   call asm_vsprintf
   
   pop ix
   ret
