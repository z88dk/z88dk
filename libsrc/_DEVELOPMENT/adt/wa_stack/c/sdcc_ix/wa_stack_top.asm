
; void *wa_stack_top(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC _wa_stack_top

EXTERN _w_array_back

defc _wa_stack_top = _w_array_back

INCLUDE "adt/wa_stack/z80/asm_wa_stack_top.asm"
