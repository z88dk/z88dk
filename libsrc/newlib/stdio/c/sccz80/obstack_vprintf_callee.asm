
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC obstack_vprintf_callee

EXTERN asm_obstack_vprintf

obstack_vprintf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_obstack_vprintf
