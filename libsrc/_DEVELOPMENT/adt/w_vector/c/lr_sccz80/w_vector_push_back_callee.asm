
; size_t w_vector_push_back(w_vector_t *v, void *item)

XDEF w_vector_push_back_callee

LIB w_vector_append_callee

;defc w_vector_push_back_callee = w_vector_append_callee

w_vector_push_back_callee:

   jp w_vector_append_callee

INCLUDE "adt/w_vector/z80/asm_w_vector_push_back.asm"
