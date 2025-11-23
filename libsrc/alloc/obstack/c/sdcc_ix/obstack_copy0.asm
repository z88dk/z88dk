
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_copy0

EXTERN asm_obstack_copy0

_obstack_copy0:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp asm_obstack_copy0
