
; int ba_stack_pop_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_pop_fastcall

EXTERN asm_ba_stack_pop

defc _ba_stack_pop_fastcall = asm_ba_stack_pop
