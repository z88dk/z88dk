
; size_t w_array_append(w_array_t *a, void *item)

PUBLIC w_array_append_callee

w_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_append.asm"
