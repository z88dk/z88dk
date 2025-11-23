
; size_t wv_stack_capacity(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_capacity

EXTERN asm_wv_stack_capacity

defc wv_stack_capacity = asm_wv_stack_capacity

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_capacity
defc _wv_stack_capacity = wv_stack_capacity
ENDIF

