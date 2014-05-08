
; int ba_stack_push(ba_stack_t *s, int c)

PUBLIC _ba_stack_push

EXTERN _b_array_append

_ba_stack_push:

   jp _b_array_append

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_push.asm"
