
; void bv_stack_destroy_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_destroy_fastcall

EXTERN asm_bv_stack_destroy

defc _bv_stack_destroy_fastcall = asm_bv_stack_destroy
