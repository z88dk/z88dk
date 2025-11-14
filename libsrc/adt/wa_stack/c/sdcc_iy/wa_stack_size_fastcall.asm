
; size_t wa_stack_size_fastcall(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_size_fastcall

EXTERN asm_wa_stack_size

defc _wa_stack_size_fastcall = asm_wa_stack_size
