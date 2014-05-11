
; size_t w_vector_erase(w_vector_t *v, size_t idx)

PUBLIC w_vector_erase_callee

EXTERN w_array_erase_callee

;defc w_vector_erase_callee = w_array_erase_callee

w_vector_erase_callee:

   jp w_array_erase_callee

INCLUDE "adt/w_vector/z80/asm_w_vector_erase.asm"
