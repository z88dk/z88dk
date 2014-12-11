
; void w_vector_clear(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC _w_vector_clear

EXTERN _w_array_clear

defc _w_vector_clear = _w_array_clear

INCLUDE "adt/w_vector/z80/asm_w_vector_clear.asm"
