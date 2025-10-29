
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

SECTION code_clib
SECTION code_stdio

PUBLIC obstack_vprintf

EXTERN asm_obstack_vprintf

obstack_vprintf:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_obstack_vprintf
