
; void *w_vector_at(b_vector_t *v, size_t idx)

PUBLIC w_vector_at_callee

EXTERN w_array_at_callee

;defc w_vector_at_callee = w_array_at_callee

w_vector_at_callee:

   jp w_array_at_callee

INCLUDE "adt/w_vector/z80/asm_w_vector_at.asm"
