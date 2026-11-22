
; int bv_stack_empty(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_empty

EXTERN asm_bv_stack_empty

defc bv_stack_empty = asm_bv_stack_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_empty
defc _bv_stack_empty = bv_stack_empty
ENDIF

