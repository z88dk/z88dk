
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

PUBLIC _ba_priority_queue_init

_ba_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   pop ix

   push ix
   push bc
   push de
   push hl
   push af

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_init.asm"
