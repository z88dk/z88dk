
; void w_vector_empty(w_vector_t *v)

SECTION seg_code_w_vector

PUBLIC _w_vector_empty

EXTERN _w_array_empty

defc _w_vector_empty = _w_array_empty

INCLUDE "adt/w_vector/z80/asm_w_vector_empty.asm"
