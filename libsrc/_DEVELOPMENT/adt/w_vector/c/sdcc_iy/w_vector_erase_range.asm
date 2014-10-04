
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

SECTION seg_code_w_vector

PUBLIC _w_vector_erase_range

EXTERN _w_array_erase_range

defc _w_vector_erase_range = _w_array_erase_range

INCLUDE "adt/w_vector/z80/asm_w_vector_erase_range.asm"
