
; size_t obstack_object_size_fastcall(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_object_size_fastcall

EXTERN asm_obstack_object_size

defc _obstack_object_size_fastcall = asm_obstack_object_size
