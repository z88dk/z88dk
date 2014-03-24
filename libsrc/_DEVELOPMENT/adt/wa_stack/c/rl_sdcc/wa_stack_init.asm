
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

XDEF wa_stack_init

LIB w_array_init

defc wa_stack_init = w_array_init

INCLUDE "adt/wa_stack/z80/asm_wa_stack_init.asm"
