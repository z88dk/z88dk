
; int w_vector_shrink_to_fit(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC w_vector_shrink_to_fit

defc w_vector_shrink_to_fit = asm_w_vector_shrink_to_fit

INCLUDE "adt/w_vector/z80/asm_w_vector_shrink_to_fit.asm"
