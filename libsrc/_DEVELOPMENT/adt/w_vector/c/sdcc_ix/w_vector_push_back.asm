
; size_t w_vector_push_back(w_vector_t *v, int c)

SECTION seg_code_w_vector

PUBLIC _w_vector_push_back

EXTERN _w_vector_append

defc _w_vector_push_back = _w_vector_append

INCLUDE "adt/w_vector/z80/asm_w_vector_push_back.asm"
