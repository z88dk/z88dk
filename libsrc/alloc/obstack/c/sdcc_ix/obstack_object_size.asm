
; size_t obstack_object_size(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_object_size

EXTERN asm_obstack_object_size

_obstack_object_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_obstack_object_size
