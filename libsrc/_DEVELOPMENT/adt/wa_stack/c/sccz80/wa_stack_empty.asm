
; int wa_stack_empty(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC wa_stack_empty

defc wa_stack_empty = asm_wa_stack_empty

INCLUDE "adt/wa_stack/z80/asm_wa_stack_empty.asm"
