
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XDEF w_vector_erase

LIB w_array_erase

defc w_vector_erase = w_array_erase

INCLUDE "../../z80/asm_w_vector_erase.asm"
