
; int bv_stack_reserve(bv_stack_t *s, size_t n)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_reserve

EXTERN _b_vector_reserve

defc _bv_stack_reserve = _b_vector_reserve

INCLUDE "adt/bv_stack/z80/asm_bv_stack_reserve.asm"
