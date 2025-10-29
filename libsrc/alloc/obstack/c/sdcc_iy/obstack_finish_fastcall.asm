
; void *obstack_finish_fastcall(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_finish_fastcall

EXTERN asm_obstack_finish

defc _obstack_finish_fastcall = asm_obstack_finish
