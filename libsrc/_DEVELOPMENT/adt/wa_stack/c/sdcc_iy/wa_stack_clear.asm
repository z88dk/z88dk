
; void wa_stack_clear(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC _wa_stack_clear

EXTERN _w_array_clear

defc _wa_stack_clear = _w_array_clear

INCLUDE "adt/wa_stack/z80/asm_wa_stack_clear.asm"
