
; void wa_stack_destroy_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_destroy_fastcall

EXTERN asm_wa_stack_destroy

defc _wa_stack_destroy_fastcall = asm_wa_stack_destroy
