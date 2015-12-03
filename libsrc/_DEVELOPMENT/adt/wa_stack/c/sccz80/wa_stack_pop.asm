
; void *wa_stack_pop(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_pop

EXTERN asm_wa_stack_pop

defc wa_stack_pop = asm_wa_stack_pop
