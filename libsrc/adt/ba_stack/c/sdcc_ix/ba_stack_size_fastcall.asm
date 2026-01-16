
; size_t ba_stack_size_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_size_fastcall

EXTERN asm_ba_stack_size

defc _ba_stack_size_fastcall = asm_ba_stack_size
