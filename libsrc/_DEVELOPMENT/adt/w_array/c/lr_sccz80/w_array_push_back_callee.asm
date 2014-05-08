
; size_t w_array_push_back(w_array_t *a, void *item)

PUBLIC w_array_push_back_callee

EXTERN w_array_append_callee

;defc w_array_push_back_callee = w_array_append_callee

w_array_push_back_callee:

   jp w_array_append_callee

INCLUDE "adt/w_array/z80/asm_w_array_push_back.asm"
