
; size_t w_array_push_back(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_push_back_callee

EXTERN w_array_append_callee

defc w_array_push_back_callee = w_array_append_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_push_back_callee
defc _w_array_push_back_callee = w_array_push_back_callee
ENDIF

