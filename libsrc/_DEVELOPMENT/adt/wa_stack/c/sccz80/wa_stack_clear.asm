
; void wa_stack_clear(wa_stack_t *s)

SECTION seg_code_wa_stack

PUBLIC wa_stack_clear

defc wa_stack_clear = asm_wa_stack_clear

INCLUDE "adt/wa_stack/z80/asm_wa_stack_clear.asm"
