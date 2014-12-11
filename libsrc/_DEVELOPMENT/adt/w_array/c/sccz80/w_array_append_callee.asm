
; size_t w_array_append(w_array_t *a, void *item)

SECTION code_adt_w_array

PUBLIC w_array_append_callee

w_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_append.asm"
