
; int obstack_grow(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_grow

EXTERN asm_obstack_grow

_obstack_grow:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_obstack_grow
