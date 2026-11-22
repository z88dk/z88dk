
; int bv_stack_top_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_top_fastcall

EXTERN asm_bv_stack_top

defc _bv_stack_top_fastcall = asm_bv_stack_top
