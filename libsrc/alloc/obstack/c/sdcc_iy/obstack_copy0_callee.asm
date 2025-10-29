
; void *obstack_copy0_callee(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_copy0_callee

EXTERN asm_obstack_copy0

_obstack_copy0_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   jp asm_obstack_copy0
