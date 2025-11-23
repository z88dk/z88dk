
; size_t bv_stack_max_size_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_max_size_fastcall

EXTERN asm_bv_stack_max_size

defc _bv_stack_max_size_fastcall = asm_bv_stack_max_size
