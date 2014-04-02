
; void b_vector_clear(b_vector_t *v)

XDEF _b_vector_clear

LIB _b_array_clear

_b_vector_clear:

   jp _b_array_clear

   INCLUDE "adt/b_vector/z80/asm_b_vector_clear.asm"
