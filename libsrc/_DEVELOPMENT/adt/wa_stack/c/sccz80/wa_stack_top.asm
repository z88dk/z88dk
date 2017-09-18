
; void *wa_stack_top(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_top

EXTERN asm_wa_stack_top

defc wa_stack_top = asm_wa_stack_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_top
defc _wa_stack_top = wa_stack_top
ENDIF

