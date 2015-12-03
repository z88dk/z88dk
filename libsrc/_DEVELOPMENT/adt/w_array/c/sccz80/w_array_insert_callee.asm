
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_insert_callee

EXTERN asm_w_array_insert

w_array_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_w_array_insert
