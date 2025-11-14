
; void wa_stack_destroy(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_destroy

EXTERN asm_wa_stack_destroy

defc wa_stack_destroy = asm_wa_stack_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_destroy
defc _wa_stack_destroy = wa_stack_destroy
ENDIF

