
; void wa_stack_clear_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_clear_fastcall

EXTERN asm_wa_stack_clear

defc _wa_stack_clear_fastcall = asm_wa_stack_clear
