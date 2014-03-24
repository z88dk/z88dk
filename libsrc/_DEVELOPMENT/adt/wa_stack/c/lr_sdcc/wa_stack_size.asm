
; size_t wa_stack_size(wa_stack_t *s)

XDEF wa_stack_size

LIB w_array_size

defc wa_stack_size = w_array_size

INCLUDE "adt/wa_stack/z80/asm_wa_stack_size.asm"
