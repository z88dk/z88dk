
; void *obstack_base_fastcall(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_base_fastcall

EXTERN asm_obstack_base

defc _obstack_base_fastcall = asm_obstack_base
