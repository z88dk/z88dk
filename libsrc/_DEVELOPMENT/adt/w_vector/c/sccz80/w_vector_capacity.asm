
; size_t w_vector_capacity(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC w_vector_capacity

defc w_vector_capacity = asm_w_vector_capacity

INCLUDE "adt/w_vector/z80/asm_w_vector_capacity.asm"
