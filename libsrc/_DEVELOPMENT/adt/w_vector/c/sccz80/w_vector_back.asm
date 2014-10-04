
; void *w_vector_back(b_vector_t *v)

SECTION seg_code_w_vector

PUBLIC w_vector_back

defc w_vector_back = asm_w_vector_back

INCLUDE "adt/w_vector/z80/asm_w_vector_back.asm"
