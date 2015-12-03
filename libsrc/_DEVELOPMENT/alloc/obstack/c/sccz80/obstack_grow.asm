
; int obstack_grow(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_grow

EXTERN asm_obstack_grow

obstack_grow:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_obstack_grow
