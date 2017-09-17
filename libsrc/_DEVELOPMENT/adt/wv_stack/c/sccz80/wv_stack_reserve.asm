
; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_reserve

EXTERN w_vector_reserve

defc wv_stack_reserve = w_vector_reserve

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_reserve
defc _wv_stack_reserve = wv_stack_reserve
ENDIF

