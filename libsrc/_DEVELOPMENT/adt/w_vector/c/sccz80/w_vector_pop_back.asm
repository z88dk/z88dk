
; void *w_vector_pop_back(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC w_vector_pop_back

defc w_vector_pop_back = asm_w_vector_pop_back

INCLUDE "adt/w_vector/z80/asm_w_vector_pop_back.asm"
