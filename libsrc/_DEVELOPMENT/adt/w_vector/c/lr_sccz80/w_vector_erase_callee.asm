
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XDEF w_vector_erase_callee

LIB w_array_erase_callee

defc w_vector_erase_callee = w_array_erase_callee

INCLUDE "../../z80/asm_w_vector_erase.asm"
