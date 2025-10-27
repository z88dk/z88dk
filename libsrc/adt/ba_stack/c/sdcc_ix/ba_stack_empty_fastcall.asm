
; int ba_stack_empty_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_empty_fastcall

EXTERN asm_ba_stack_empty

defc _ba_stack_empty_fastcall = asm_ba_stack_empty
