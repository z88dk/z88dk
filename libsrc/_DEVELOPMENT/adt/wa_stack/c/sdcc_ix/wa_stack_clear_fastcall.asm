
; void wa_stack_clear_fastcall(wa_stack_t *s)

SECTION code_adt_wa_stack

PUBLIC _wa_stack_clear_fastcall

defc _wa_stack_clear_fastcall = asm_wa_stack_clear

INCLUDE "adt/wa_stack/z80/asm_wa_stack_clear.asm"
