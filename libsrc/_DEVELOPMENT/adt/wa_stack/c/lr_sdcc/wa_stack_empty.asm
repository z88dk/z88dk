
; int wa_stack_empty(wa_stack_t *s)

XDEF wa_stack_empty

LIB w_array_empty

defc wa_stack_empty = w_array_empty

INCLUDE "adt/wa_stack/z80/asm_wa_stack_empty.asm"
