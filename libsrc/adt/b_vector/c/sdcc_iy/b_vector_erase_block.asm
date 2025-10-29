
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_erase_block

EXTERN _b_array_erase_block

defc _b_vector_erase_block = _b_array_erase_block
