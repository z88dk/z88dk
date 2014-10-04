
; int bv_stack_empty(bv_stack_t *s)

SECTION seg_code_bv_stack

PUBLIC _bv_stack_empty

EXTERN _b_vector_empty

defc _bv_stack_empty = _b_vector_empty

INCLUDE "adt/bv_stack/z80/asm_bv_stack_empty.asm"
