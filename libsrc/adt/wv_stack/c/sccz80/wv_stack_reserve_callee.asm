
; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_reserve_callee

EXTERN w_vector_reserve_callee

defc wv_stack_reserve_callee = w_vector_reserve_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_reserve_callee
defc _wv_stack_reserve_callee = wv_stack_reserve_callee
ENDIF

