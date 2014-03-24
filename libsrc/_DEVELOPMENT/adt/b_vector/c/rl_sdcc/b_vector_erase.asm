
; size_t b_vector_erase(b_vector_t *v, size_t idx)

XDEF b_vector_erase

LIB b_array_erase

defc b_vector_erase = b_array_erase

INCLUDE "adt/b_vector/z80/asm_b_vector_erase.asm"
