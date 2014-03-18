
; void b_vector_clear(b_vector_t *v)

XDEF b_vector_clear

LIB b_array_clear

defc b_vector_clear = b_array_clear

INCLUDE "../../z80/asm_b_vector_clear.asm"
