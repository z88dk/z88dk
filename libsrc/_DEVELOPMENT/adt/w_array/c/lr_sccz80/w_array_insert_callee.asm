
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

XDEF w_array_insert_callee

w_array_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_insert.asm"
