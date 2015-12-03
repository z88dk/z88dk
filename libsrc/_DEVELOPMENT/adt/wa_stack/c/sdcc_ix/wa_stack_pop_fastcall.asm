
; void *wa_stack_pop_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_pop_fastcall

EXTERN asm_wa_stack_pop

defc _wa_stack_pop_fastcall = asm_wa_stack_pop
