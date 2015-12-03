
; int w_array_empty(b_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_empty

EXTERN asm_w_array_empty

defc w_array_empty = asm_w_array_empty
