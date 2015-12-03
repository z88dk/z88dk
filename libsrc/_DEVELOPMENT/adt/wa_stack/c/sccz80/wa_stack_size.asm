
; size_t wa_stack_size(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_size

EXTERN asm_wa_stack_size

defc wa_stack_size = asm_wa_stack_size
