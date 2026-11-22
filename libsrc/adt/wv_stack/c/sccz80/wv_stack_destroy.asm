
; void wv_stack_destroy(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_destroy

EXTERN asm_wv_stack_destroy

defc wv_stack_destroy = asm_wv_stack_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_destroy
defc _wv_stack_destroy = wv_stack_destroy
ENDIF

