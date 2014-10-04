
; size_t wa_stack_size(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC _wa_stack_size

EXTERN _w_array_size

defc _wa_stack_size = _w_array_size

INCLUDE "adt/wa_stack/z80/asm_wa_stack_size.asm"
