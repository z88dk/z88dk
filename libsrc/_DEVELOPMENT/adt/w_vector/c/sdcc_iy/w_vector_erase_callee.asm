
; size_t w_vector_erase_callee(w_vector_t *v, size_t idx)

SECTION code_adt_w_vector

PUBLIC _w_vector_erase_callee

EXTERN _w_array_erase_callee

defc _w_vector_erase_callee = _w_array_erase_callee

INCLUDE "adt/w_vector/z80/asm_w_vector_erase.asm"
