
; int wv_stack_empty(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_empty

EXTERN asm_wv_stack_empty

defc wv_stack_empty = asm_wv_stack_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_empty
defc _wv_stack_empty = wv_stack_empty
ENDIF

