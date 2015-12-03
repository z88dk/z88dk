
; size_t w_array_size(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_size

EXTERN asm_w_array_size

defc w_array_size = asm_w_array_size
