
; size_t bv_stack_max_size(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_max_size

EXTERN asm_bv_stack_max_size

defc bv_stack_max_size = asm_bv_stack_max_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_max_size
defc _bv_stack_max_size = bv_stack_max_size
ENDIF

