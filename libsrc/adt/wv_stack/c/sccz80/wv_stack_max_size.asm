
; size_t wv_stack_max_size(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_max_size

EXTERN asm_wv_stack_size

defc wv_stack_max_size = asm_wv_stack_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_max_size
defc _wv_stack_max_size = wv_stack_max_size
ENDIF

