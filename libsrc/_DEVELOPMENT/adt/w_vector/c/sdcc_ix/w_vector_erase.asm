
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XDEF w_vector_erase

LIB w_array_erase

w_vector_erase:

   jp w_array_erase

   INCLUDE "adt/w_vector/z80/asm_w_vector_erase.asm"
