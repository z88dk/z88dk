
; void bv_stack_destroy(bv_stack_t *s)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_destroy

EXTERN _b_vector_destroy

defc _bv_stack_destroy = _b_vector_destroy

INCLUDE "adt/bv_stack/z80/asm_bv_stack_destroy.asm"
