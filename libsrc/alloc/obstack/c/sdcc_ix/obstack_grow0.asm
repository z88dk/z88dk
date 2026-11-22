
; int obstack_grow0(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_grow0

EXTERN asm_obstack_grow0

_obstack_grow0:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_obstack_grow0
