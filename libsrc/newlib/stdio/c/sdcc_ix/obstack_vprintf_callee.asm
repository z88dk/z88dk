
; int obstack_vprintf_callee(struct obstack *obstack, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _obstack_vprintf_callee, l0_obstack_vprintf_callee

EXTERN asm_obstack_vprintf

_obstack_vprintf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_obstack_vprintf_callee:

   push ix
   
   call asm_obstack_vprintf
   
   pop ix
   ret
