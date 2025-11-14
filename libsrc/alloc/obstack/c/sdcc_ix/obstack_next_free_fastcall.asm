
; void *obstack_next_free_fastcall(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_next_free_fastcall

EXTERN asm_obstack_next_free

defc _obstack_next_free_fastcall = asm_obstack_next_free
