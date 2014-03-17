
; int b_vector_pop_back(b_vector_t *v)

XDEF b_vector_pop_back

LIB b_array_pop_back

defc b_vector_pop_back = b_array_pop_back

INCLUDE "../../z80/asm_b_vector_pop_back.asm"
