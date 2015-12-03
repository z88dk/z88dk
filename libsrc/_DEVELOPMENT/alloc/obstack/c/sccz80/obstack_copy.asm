
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_copy

EXTERN asm_obstack_copy

obstack_copy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_obstack_copy
