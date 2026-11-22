
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_copy

EXTERN asm_obstack_copy

_obstack_copy:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp asm_obstack_copy
