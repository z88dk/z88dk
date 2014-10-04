
; size_t w_vector_erase(w_vector_t *v, size_t idx)

SECTION seg_code_w_vector

PUBLIC _w_vector_erase

EXTERN _w_array_erase

defc _w_vector_erase = _w_array_erase

INCLUDE "adt/w_vector/z80/asm_w_vector_erase.asm"
