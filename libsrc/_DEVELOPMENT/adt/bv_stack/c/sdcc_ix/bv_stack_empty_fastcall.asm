
; int bv_stack_empty_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_empty_fastcall

EXTERN asm_bv_stack_empty

defc _bv_stack_empty_fastcall = asm_bv_stack_empty
