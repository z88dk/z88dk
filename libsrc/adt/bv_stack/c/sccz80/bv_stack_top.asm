
; int bv_stack_top(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_top

EXTERN asm_bv_stack_top

defc bv_stack_top = asm_bv_stack_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_top
defc _bv_stack_top = bv_stack_top
ENDIF

