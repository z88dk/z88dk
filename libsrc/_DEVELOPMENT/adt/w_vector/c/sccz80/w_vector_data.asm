
; void *w_vector_data(b_vector_t *v)

SECTION seg_code_w_vector

PUBLIC w_vector_data

defc w_vector_data = asm_w_vector_data

INCLUDE "adt/w_vector/z80/asm_w_vector_data.asm"
