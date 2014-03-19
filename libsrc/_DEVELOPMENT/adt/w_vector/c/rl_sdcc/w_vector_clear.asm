
; void w_vector_clear(w_vector_t *v)

XDEF w_vector_clear

LIB w_array_clear

defc w_vector_clear = w_array_clear

INCLUDE "../../z80/asm_w_vector_clear.asm"
