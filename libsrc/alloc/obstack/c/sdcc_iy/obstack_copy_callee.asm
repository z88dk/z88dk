
; void *obstack_copy_callee(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_copy_callee

EXTERN asm_obstack_copy

_obstack_copy_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   jp asm_obstack_copy
