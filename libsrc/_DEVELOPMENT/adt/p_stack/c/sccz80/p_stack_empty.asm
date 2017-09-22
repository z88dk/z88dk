
; int p_stack_empty(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_empty

EXTERN asm_p_stack_empty

defc p_stack_empty = asm_p_stack_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_empty
defc _p_stack_empty = p_stack_empty
ENDIF

