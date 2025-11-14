
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _obstack_vprintf

EXTERN asm_obstack_vprintf

_obstack_vprintf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_obstack_vprintf
