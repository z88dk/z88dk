
; int bv_stack_pop_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_pop_fastcall

EXTERN asm_bv_stack_pop

defc _bv_stack_pop = asm_bv_stack_pop
