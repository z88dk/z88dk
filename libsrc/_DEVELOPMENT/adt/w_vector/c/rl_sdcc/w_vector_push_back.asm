
; size_t w_vector_push_back(w_vector_t *v, int c)

XDEF w_vector_push_back

LIB w_vector_append

defc w_vector_push_back = w_vector_append

INCLUDE "../../z80/asm_w_vector_push_back.asm"
