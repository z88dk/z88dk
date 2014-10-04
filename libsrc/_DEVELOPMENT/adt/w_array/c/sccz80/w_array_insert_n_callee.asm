
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

SECTION seg_code_w_array

PUBLIC w_array_insert_n_callee

w_array_insert_n_callee:

   pop hl
   pop af
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_insert_n.asm"
