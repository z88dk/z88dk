
; size_t wa_stack_size(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC wa_stack_size

defc wa_stack_size = asm_wa_stack_size

INCLUDE "adt/wa_stack/z80/asm_wa_stack_size.asm"
