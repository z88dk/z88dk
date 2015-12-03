
; void *w_array_pop_back(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_pop_back

EXTERN asm_w_array_pop_back

defc w_array_pop_back = asm_w_array_pop_back
