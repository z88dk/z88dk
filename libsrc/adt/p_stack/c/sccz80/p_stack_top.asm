
; void *p_stack_top(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_top

EXTERN asm_p_stack_top

defc p_stack_top = asm_p_stack_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_top
defc _p_stack_top = p_stack_top
ENDIF

